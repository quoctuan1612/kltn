module Admin
  class AttemptsController < AdminBaseController
    before_action :load_attempt
    
    def show_detail
    end

    def destroy
      if @attempt.destroy
        flash[:success] = "Xóa kết quả thành công!"
      else
        flash[:danger] = "Xóa kết quả thất bại!"
      end
      redirect_back fallback_location: attempts_in_exam_admin_exam_path(@attempt.exam)
    end

    private

    def load_attempt
      @attempt = Attempt.eager_load(:exam, attempt_questions: [question: :answers]).find_by id: params[:id]
      return if @attempt
      flash[:danger] = "Lượt thi không hợp lệ"
      redirect_to root_path
    end
  end
end
