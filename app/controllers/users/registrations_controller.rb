class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    super do |user|
      SendWelcomeEmailJob.perform_later(user.id)
    end
  end

end
