class StaticPagesController < ApplicationController
  
  def home
    attempts = current_user.attempts
      .by_exam_id(params[:exam_id])
      .by_category_id(params[:category_id])
      .by_status(params[:status])
      .by_result(params[:result])
      .eager_load(:exam, attempt_questions: [question: :answers])
    @attempts = attempts.order_created_at.paginate(page: params[:page], per_page: Settings.per_page_30)
    respond_to do |format|
      format.js
      format.html
    end
  end
end
