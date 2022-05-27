module Admin
  class CategoriesController < AdminBaseController
    before_action :verify_admin!
    before_action :load_category, except: %i(index new create)

    def index
      @categories = Category.ransack(params[:q]).result(distinct: true).order_created_at.paginate(page: params[:page], per_page: Settings.per_page_10)
      respond_to do |format|
        format.js
        format.html
      end
    end

    def new
      @category = Category.new
      @title = "Thêm mới danh mục"
    end

    def create
      @category = Category.new category_params
      if @category.save
        flash[:success] = "Tạo danh mục thành công"
        redirect_to admin_categories_path
      else
        flash.now[:danger] = "Tạo danh mục thất bại"
        @title = "Thêm mới danh mục"
        respond_to do |format|
          format.js {render action: "respond_js.js.erb"}
        end
      end
    end

    def edit
      @title = "Cập nhật danh mục"
    end

    def update
      if @category.update_attributes category_params
        flash[:success] = "Cập nhật danh mục thành công"
        redirect_to admin_categories_path
      else
        flash.now[:danger] = "Cập nhật danh mục thất bại"
        @title = "Cập nhật danh mục"
        respond_to do |format|
          format.js {render action: "respond_js.js.erb"}
        end
      end
    end

    def show
      authorize @category
    end

    def destroy
      if @category.exams.any? || @category.questions.any?
        flash[:danger] = "Không thể xóa vì danh mục đã được sử dụng"
      elsif @category.destroy
        flash[:success] = "Xóa thành công"
      else
        flash[:danger] = "Xóa thất bại"
      end
      redirect_back fallback_location: admin_categories_path
    end

    private

    def category_params
      params.require(:category).permit(:name, :description)
    end

    def load_category
      @category = Category.find_by id: params[:id]
      return if @category
      flash[:danger] = "Không tìm thấy danh mục"
      redirect_back fallback_location: admin_root_path
    end

    def verify_admin!
      return if current_user.admin?
      flash[:danger] = "Bạn không có quyền truy cập"
      redirect_back(fallback_location: root_path)
    end

    def pundit_user
      User.all.second
    end
  end
end
