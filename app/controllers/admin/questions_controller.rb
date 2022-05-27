module Admin
  class QuestionsController < AdminBaseController
    before_action :load_question, except: %i(index create new)

    def index
      @questions = Question.ransack(params[:q]).result(distinct: true).order_created_at
      @questions = @questions.by_category_ids(params[:category_id]).by_user_ids(params[:user_id])
        .by_levels(params[:level]).by_type(params[:type])
        .paginate(page: params[:page], per_page: Settings.per_page_20)
      respond_to do |format|
        format.js
        format.html
      end
    end

    def new
      @question = Question.new
      @answers = @question.answers.build
    end

    def create
      @question = Question.new question_params
      if @question.save
        flash[:success] = "Tạo câu hỏi thành công"
        redirect_to admin_questions_path
      else
        flash.now[:danger] = "Tạo câu hỏi thất bại"
        render :new
      end
    end

    def edit
    end

    def update
      if @question.update_attributes question_params
        flash[:success] = "Cập nhật câu hỏi thành công"
        redirect_to admin_questions_path
      else
        flash.now[:danger] = "Cập nhật câu hỏi thất bại"
        render :edit
      end
    end

    def show
    end

    def destroy
      if @question.attempt_questions.any?
        flash[:danger] = "Không thể xóa vì câu hỏi đã được sử dụng"
      elsif @question.destroy
        flash[:success] = "Xóa thành công"
      else
        flash[:danger] = "Xóa thất bại"
      end
      redirect_back fallback_location: admin_questions_path
    end

    private

    def question_params
      params.require(:question).permit :user_id, :level, :category_id, :question_type, :content, 
        answers_attributes: %i(id question_id content is_true _destroy)
    end

    def load_question
      @question = Question.find_by id: params[:id]
      return if @question
      flash[:danger] = "Không tìm thấy câu hỏi"
      redirect_to admin_questions_path
    end
  end
end
