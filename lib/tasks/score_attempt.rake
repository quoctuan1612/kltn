namespace :db do
  task score_attempt: :environment do
    puts "Add score attempt"
    Attempt.all.each do |attempt|
      final_score = 0
      attempt.attempt_questions.eager_load(question: :answers).each do |attempt_question|
        list_true_answers_id = attempt_question.question.answers.true_answer.collect{|answer| "#{answer.id}"}
        if attempt_question.selected_answer.sort == list_true_answers_id.sort
          final_score += 1
        end
      end
      attempt.update_column(:score, final_score)
    end
  end
end
