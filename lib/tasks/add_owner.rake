namespace :db do
  task add_owner_and_level: :environment do
    puts "Add owner and level"
    Exam.update_all(user_id: User.first.id)
    Question.update_all(user_id: User.first.id)
  end
end
