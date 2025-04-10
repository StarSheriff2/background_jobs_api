class SendWelcomeEmailJob < ApplicationJob
  queue_as :mailers

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.welcome_email(user).deliver_now
  end
end
