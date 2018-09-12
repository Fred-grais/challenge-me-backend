module AuthenticationHelper

  def authenticate_user user
    authentication_headers = user.create_new_auth_token
    sign_in user

    yield(authentication_headers)
  end
end