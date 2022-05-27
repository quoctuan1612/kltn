class Admin::DashboardController < Admin::AdminBaseController
  def index
    @count_trainee = User.trainee.size
    @count_trainer = User.trainer.size
    @count_category = Category.all.size
    @count_question = Question.all.size
    @count_exam = Exam.all.size
  end
end
