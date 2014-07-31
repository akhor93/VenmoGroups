class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper :application

  def require_login
    if session[:user_id]
      return true
    end
    flash[:warning] = 'Please login to continue'
    redirect_to :controller => :welcome, :action => :index
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end
end
