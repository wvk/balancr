class RegistrationsController < ApplicationController

  # GET /registration
  def show
    redirect_to :action => :new
  end

  # GET /registrations/new
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /registrations
  # POST /registrations.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'Du hast dich erfolgreich registriert und kannst dich nun einloggen') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  protected

  def perform_basic_auth
    authorize! :access, :registration
  end

  def access_denied
    redirect_to dashboard_path
  end

end
