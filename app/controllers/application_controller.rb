class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  load_and_authorize_resource
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  before_filter :add_allow_credentials_headers

  def add_allow_credentials_headers
    response.headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'
    response.headers['Access-Control-Allow-Credentials'] = 'true'
  end

  def options
    head :status => 200, :'Access-Control-Allow-Headers' => 'accept, content-type'
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || ''
  end

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end

  def user
    respond_to do |format|
      format.html {}
      format.json { render :json => current_user }
    end
  end
end
