class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  check_authorization
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    return redirect_to questions_path, alert: 'Error. Check if your provider account contains email' unless @user

    return unless @user.persisted?

    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
  end

  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    return redirect_to questions_path, alert: 'Error. Check if your provider account contains email' unless @user

    return unless @user.persisted?

    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
  end
end
