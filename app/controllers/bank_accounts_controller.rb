class BankAccountsController < ApplicationController
  # GET /bank_account/1
  # GET /bank_account/1.xml
  def show
    @bank_account = current_user.bank_account

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bank_account }
    end
  end

  # GET /bank_account/new
  # GET /bank_account/new.xml
  def new
    @bank_account = BankAccount.new :owner => current_user

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bank_account }
    end
  end

  # GET /bank_account/1/edit
  def edit
    @bank_account = current_user.bank_account
  end

  # POST /bank_account
  # POST /bank_account.xml
  def create
    @bank_account = current_user.build_bank_account(params[:bank_account])

    respond_to do |format|
      if @bank_account.save
        format.html { redirect_to(dashboard_path, :notice => 'Bank account was successfully created.') }
        format.xml  { render :xml => @bank_account, :status => :created, :location => dashboard_path }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @bank_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bank_account/1
  # PUT /bank_account/1.xml
  def update
    @bank_account = current_user.bank_account

    respond_to do |format|
      if @bank_account.update_attributes(params[:bank_account])
        format.html { redirect_to(dashboard_path, :notice => 'Bank account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @bank_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bank_account/1
  # DELETE /bank_account/1.xml
  def destroy
    @bank_account = current_user.bank_account
    @bank_account.destroy

    respond_to do |format|
      format.html { redirect_to(dashboard_path) }
      format.xml  { head :ok }
    end
  end
end
