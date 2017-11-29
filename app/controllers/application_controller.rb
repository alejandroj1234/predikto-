class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :set_csrf_cookie

  # Allows cookies with csrf token to post delete update
  def set_csrf_cookie
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  # Used to direct users to dashboard after login
  def stored_location_for(resource)
    nil
  end

  # Used to direct users to dashboard after login
  def after_sign_in_path_for(resource)
    '/dashboard'
  end

  protected
  # Needed to configure the additional parameters for devise users
  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end
end