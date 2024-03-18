class Users::SessionsController < Devise::SessionsController
  def destroy
    Analytics::Event.user_signed_out(current_user, cookies)
    super
  end
end
