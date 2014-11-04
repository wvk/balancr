class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def password
    @user = User.find(params[:user_id])

    respond_to do |format|
      format.html # password.html.erb
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { back_or_default }
      format.xml  { head :ok }
    end
  end

  def projects
    @user = User.find(params[:user_id])
    @projects = @user.projects

    respond_to do |format|
      format.xml  { render :xml  => @projects }
      format.json { render :json => @projects }
    end
  end

  def balance
    @users = User.order(:forename, :surname)
    respond_to do |format|
      format.txt do
        text = @users.map do |user|
          "#{user.full_name}:\n" + user.friends.map{|b_user| user.payment_instruction_for(b_user, true) }.compact.join("\n")
        end
        render :text => text.join("\n\n")
      end
      format.csv do
        csv = CSV.generate do |csv|
          csv << ['User'] + @users.map(&:full_name)
          @users.each do |user|
            csv << [user.full_name] + @users.map {|balance_user| user.balance_to balance_user }
          end
        end
        render :text => csv
      end
    end
  end

  protected

  def default_path
    users_path
  end

  def perform_basic_auth
    if %w(edit update show password).include? params[:action]
      authorize! :edit, current_user
    else
      authorize! :access, User
    end
  end

end
