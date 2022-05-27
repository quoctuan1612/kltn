class AttemptsController < ApplicationController
  before_action :load_attempt, except: %i(index create new check_any_pending)
  before_action :is_finish?, only: %i(show update)

  def show
  end

  def create
    unless params.dig(:attempt, :exam_id).present?
      flash[:danger] = "Bạn chưa chọn đề thi!"
      redirect_to root_path
      return
    end
    return redirect_to root_path if check_password()
    @attempt = Attempt.new attempt_params.merge(attempt_questions_attributes: attempt_questions_params || {})
    if @attempt.save
      redirect_to attempt_path(@attempt)
    else
      flash[:danger] = "Bạn đã hết lượt làm đề thi này!"
      redirect_to root_path
    end
  end

  def update
    params_attempt_questions = params[:attempt][:attempt_questions_attributes].permit!.to_h
    params_attempt_questions.each do |attempt_question|
      answers_multichoice = []
      if attempt_question[1][:selected_answer].nil?
        next
      elsif attempt_question[1][:selected_answer].instance_of? String
        answers_multichoice << attempt_question[1][:selected_answer]
      else 
        attempt_question[1][:selected_answer].each do |answer|
          answers_multichoice << answer[1][:answer]
        end
      end
      attempt_question[1][:selected_answer] = answers_multichoice.reject{ |n| n == "0" }
    end
    params[:attempt][:attempt_questions_attributes] = params_attempt_questions
    if @attempt.update_attributes params[:attempt].permit!
      flash[:success] = "Nộp bài thành công!"
      redirect_to root_path
    else
      flash[:danger] = "Nộp bài thất bại!"
      redirect_back fallback_location: root_path
    end
  end

  def show_detail
  end

  def check_any_pending
    data = {}
    data[:have_pending] = false
    pending_attempts = current_user.attempts.by_exam_id(params[:exam_id]).pending
    if pending_attempts.any?
      data[:have_pending] = true
      data[:pending_attempt_id] = pending_attempts.last&.id
    end
    render json: { success: true, data: data }
  rescue
    render json: {success: false}
  end

  private

  def is_finish?
    return unless @attempt.finish?
    flash[:danger] = "Bài thi đã hoàn thành không thể chỉnh sửa hoặc xóa"
    redirect_back fallback_location: root_path
  end

  def attempt_params
    params.require(:attempt).permit :user_id, :exam_id
  end

  def attempt_questions_params
    attempt_questions_attributes = {}
    @exam = Exam.find_by id: params.dig(:attempt, :exam_id)
    return unless @exam 
    @exam.questions.shuffle.each do |question|
      attempt_questions_attributes["#{attempt_questions_attributes.size}"] = {question_id: question.id, _destroy: false}
    end
    attempt_questions_attributes
  end

  def load_attempt
    @attempt = Attempt.eager_load(:exam, attempt_questions: [question: :answers]).find_by id: params[:id]
    return if @attempt
    flash[:danger] = "Lượt thi không hợp lệ"
    redirect_to root_path
  end

  def check_password
    exam = Exam.find_by id: params.dig(:attempt, :exam_id)
    return if exam.password == params.dig(:attempt, :password)
    flash[:danger] = "Mật khẩu không chính xác!"
    return true
  end
end
