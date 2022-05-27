module Admin
  class UsersController < AdminBaseController
    before_action :verify_admin!
    before_action :load_user, except: %i(index create new)

    def index
      @users = User.ransack(params[:q]).result(distinct: true).order_created_at
        .by_role(params[:role])
        .paginate(page: params[:page], per_page: Settings.per_page_20)
      respond_to do |format|
        format.js
        format.html
      end
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new user_params
      if @user.save
        flash[:success] = "Tạo người dùng thành công"
        redirect_to admin_users_path
      else
        flash.now[:danger] = "Tạo người dùng thất bại"
        respond_to do |format|
          format.js {render action: "respond.js.erb"}
        end
      end
    end

    def edit
    end

    def update
      if @user.update_attributes user_params
        flash[:success] = "Cập nhật người dùng thành công"
        redirect_to admin_users_path
      else
        flash.now[:danger] = "Cập nhật người dùng thất bại"
        render :edit
      end
    end

    def show
    end

    def destroy
      if @user.destroy
        flash[:success] = "Xóa thành công"
      else
        flash[:danger] = "Xóa thất bại"
      end
      redirect_back fallback_location: admin_users_path
    end

    private

    def user_params
      params.require(:user).permit :email, :user_name, :password, :password_confirmation, :role, :avatar
    end

    def load_user
      @user = User.find_by id: params[:id]
      return if @user
      flash[:danger] = "Không tìm thấy người dùng"
      redirect_to admin_users_path
    end

    def verify_admin!
      return if current_user.admin?
      flash[:danger] = "Bạn không có quyền truy cập"
      redirect_back(fallback_location: root_path)
    end
  end
end
