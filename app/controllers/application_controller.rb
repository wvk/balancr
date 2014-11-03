class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :perform_basic_auth

  before_filter :store_mobile_preference

  rescue_from CanCan::AccessDenied,
      :with => :access_denied

  helper_method :current_user

  layout :select_layout

  protected

  def login!(user)
    session[:auth_user_id] = user.id
    @current_user = user
  end

  def logout!
    session[:auth_user_id] = nil
    @current_user = nil
  end

  def perform_basic_auth
    # anyone has access by default, override this method in your subclasses.
  end

  def access_denied
    flash[:error] = 'You do not have sufficient access rights to do that.'
    redirect_to dashboard_path
  end

  def current_user
    unless @current_user == false
      @current_user ||= authenticate_from_basic_auth || authenticate_from_session || false
    end
  end

  def authenticate_from_basic_auth
    authenticate_with_http_basic do |user_name, password|
      user = User.find_by_login(user_name)
      return user if user.pssword_matches?(password)
    end
  end

  def authenticate_from_session
    unless session[:auth_user_id].blank?
      return User.where(:id => session[:auth_user_id]).first
    end
  end

  def store_mobile_preference
    if %w(html mobi).include? params[:format].to_s
#       if session[:format].blank? or params[:format] != session[:format]
      session[:format] = params[:format]
#       end
      request.format = session[:format].to_sym
    end
  end

  def select_layout
    case session[:format].to_s
    when 'mobi'
      'mobile_application'
    when 'html'
      'application'
    end
  end

  def default_url_options
    if %w(html mobi).include? params[:format].to_s and session[:format]
      super.merge :format => session[:format]
    else
      super
    end
  end

end
