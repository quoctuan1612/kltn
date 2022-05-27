module Admin
  class ExamsController < AdminBaseController
    before_action :load_exam, except: %i(index create new random_questions)

    def index
      @exams = Exam.ransack(params[:q]).result(distinct: true).order_created_at
        .by_category_ids(params[:category_id])
        .by_user_ids(params[:user_id])
        .paginate(page: params[:page], per_page: Settings.per_page_10)
      respond_to do |format|
        format.js
        format.html
      end
    end

    def new
      @exam = Exam.new
      @category = Category.find_by(id: params[:category_id]) || Category.first
      respond_to do |format|
        format.js
        format.html
      end
    end

    def create
      @exam = Exam.new exam_params
      if @exam.save
        flash[:success] = "Tạo đề thi thành công"
        redirect_to admin_exams_path
      else
        flash.now[:danger] = "Tạo đề thi thất bại"
        respond_to do |format|
          format.js {render action: "respond.js.erb"}
        end
      end
    end

    def update
      if @exam.update_attributes exam_params
        flash[:success] = "Cập nhật đề thi thành công"
        redirect_to admin_exams_path
      else
        flash.now[:danger] = "Cập nhật đề thi thất bại"
        respond_to do |format|
          format.js {render action: "respond.js.erb"}
        end
      end
    end

    def edit
      @category = Category.find_by(id: params[:category_id]) || @exam.category
    end

    def destroy
      if @exam.attempts.any?
        flash[:danger] = "Không thể xóa vì đề thi đã có người làm"
      elsif @exam.destroy
        flash[:success] = "Xóa thành công"
      else
        flash[:danger] = "Xóa thất bại"
      end
      redirect_back fallback_location: admin_exams_path
    end

    def show
    end

    def attempts_in_exam
      attempts = @exam.attempts.ransack(params[:q]).result(distinct: true).by_status(params[:status]).by_result(params[:result])
      @attempts = attempts.order_created_at.paginate(page: params[:page], per_page: Settings.per_page_20)
      respond_to do |format|
        format.js
        format.html
      end
    end

    def random_questions
      data = {}
      category = Category.find_by(id: params[:category_id])
      easy_questions = category.questions.easy
      medium_questions = category.questions.medium
      hard_questions = category.questions.hard
      selected_questions = []
      data[:error_total] = category.questions.count < params[:total_request].to_i
      data[:error_hard] = false
      data[:error_medium] = false
      data[:error_easy] = false
      data[:error_easy_medium] = false
      data[:error_easy_hard] = false
      unless data[:error_total]
        if params[:hard_request] != "NaN" && params[:medium_request] != "NaN"
          easy_request = params[:total_request].to_i - params[:hard_request].to_i - params[:medium_request].to_i
          data[:error_hard] = hard_questions.count < params[:hard_request].to_i
          data[:error_medium] = medium_questions.count < params[:medium_request].to_i
          data[:error_easy] = easy_questions.count < easy_request
          if !data[:error_hard] && !data[:error_medium] && !data[:error_easy]
            selected_questions += hard_questions.pluck(:id).sample(params[:hard_request].to_i)
            selected_questions += medium_questions.pluck(:id).sample(params[:medium_request].to_i)
            selected_questions += easy_questions.pluck(:id).sample(easy_request)
          end
        elsif params[:hard_request] != "NaN" && params[:medium_request] == "NaN"
          data[:error_hard] = hard_questions.count < params[:hard_request].to_i
          easy_and_medium_question = category.questions.by_levels([:easy, :medium])
          easy_and_medium_question_need = params[:total_request].to_i - params[:hard_request].to_i
          data[:error_easy_medium] = easy_and_medium_question.size < easy_and_medium_question_need
          if !data[:error_hard] && !data[:error_easy_medium]
            selected_questions += hard_questions.pluck(:id).sample(params[:hard_request].to_i)
            selected_questions += easy_and_medium_question.pluck(:id).sample(easy_and_medium_question_need)
          end
        elsif params[:hard_request] == "NaN" && params[:medium_request] != "NaN"
          data[:error_medium] = medium_questions.count < params[:medium_request].to_i
          easy_and_hard_question = category.questions.by_levels([:easy, :hard])
          easy_and_hard_question_need = params[:total_request].to_i - params[:medium_request].to_i
          data[:error_easy_hard] = easy_and_hard_question.size  < easy_and_hard_question_need
          if !data[:error_medium] && !data[:error_easy_hard]
            selected_questions += medium_questions.pluck(:id).sample(params[:medium_request].to_i)
            selected_questions += easy_and_hard_question.pluck(:id).sample(easy_and_hard_question_need)
          end
        elsif params[:hard_request] == "NaN" && params[:medium_request] == "NaN"
          selected_questions += category.questions.pluck(:id).sample(params[:total_request].to_i)
        end
      end
      data[:selected_questions_id] = selected_questions
      render json: { success: true, data: data }
    rescue
      render json: {success: false}
    end

    private

    def load_exam
      @exam = Exam.find_by id: params[:id]
      return if @exam
      flash[:danger] = "Không tìm thấy đề thi"
      redirect_to admin_exams_path
    end

    def exam_params
      params.require(:exam).permit :category_id, :title, :duration, :result_pass, :max_number_of_times, :password, :is_show_detail_result, :user_id,
        exam_questions_attributes: %i(id question_id _destroy)
    end
  end
end
