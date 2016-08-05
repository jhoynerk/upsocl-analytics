class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path
    campaigns_path
  end

  def user
    respond_to do |format|
      format.html {}
      format.json { render :json => current_user }
    end
  end
end
