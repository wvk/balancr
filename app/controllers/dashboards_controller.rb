class DashboardsController < ApplicationController

  def show
    @users = User.in_projects(@current_user.project_ids).without(@current_user.id)
    @projects = @current_user.projects.order(:date)
  end

  protected

  def perform_basic_auth
    authorize! :access, :dashboard
  end
end
