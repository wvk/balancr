class DashboardsController < ApplicationController

  def show
    @users = User.in_projects(@current_user.project_ids).without(@current_user.id)
    @projects = @current_user.projects.order(:date)

    respond_to do |format|
      format.html
      format.mobi
    end
  end

  protected

  def perform_basic_auth
    authorize! :access, :dashboard
  end

  def access_denied
    flash[:error] = 'You need to log in first.'
    redirect_to login_path
  end

end
