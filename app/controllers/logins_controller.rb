class LoginsController < ApplicationController

  skip_before_filter :perform_basic_auth,
      :only => :destroy

  def show
    @user = User.new
  end

  def create
    user = User.find_by_login(params[:login][:login])
    if user.try(:password_matches?, params[:login][:password])
      login! user
      redirect_to dashboard_path
    else
      @user = User.new
      render :action => :show
    end
  end

  def destroy
    logout!
    redirect_to login_path
  end

  protected

  def perform_basic_auth
    authorize! :access, :login
  end

  def access_denied
    redirect_to dashboard_path
  end

end
