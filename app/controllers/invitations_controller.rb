class InvitationsController < ApplicationController

  before_filter :load_object_selections,
      :only => [:new, :edit]

  # GET /invitations
  # GET /invitations.xml
  def index
    @invitations = Invitation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invitations }
    end
  end

  # GET /invitations/1
  # GET /invitations/1.xml
  def show
    invitation = Invitation.find(params[:id])
    if [invitation.invitee_id, invitation.inviter_id] == current_user.id
      @invitation = invitation
    else
      access_denied and return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invitation }
    end
  end

  # GET /invitations/new
  # GET /invitations/new.xml
  def new
    @invitation = Invitation.new params.slice(:project_id, :user_id)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invitation }
    end
  end

  # GET /invitations/1/edit
  def edit
    @invitation = Invitation.find(params[:id])
  end

  # POST /invitations
  # POST /invitations.xml
  def create
    @invitation = Invitation.new(params[:invitation].merge :inviter => current_user)

    respond_to do |format|
      if @invitation.save
        format.html { redirect_to(@invitation, :notice => 'Invitation was successfully created.') }
        format.xml  { render :xml => @invitation, :status => :created, :location => @invitation }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invitations/1
  # PUT /invitations/1.xml
  def update
    @invitation = current_user.issued_invitations.find(params[:id])

    respond_to do |format|
      if @invitation.update_attributes(params[:invitation])
        format.html { redirect_to(@invitation, :notice => 'Invitation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.xml
  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to(invitations_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def perform_basic_auth
    authorize! :access, Invitation
  end

  def access_denied
    flash[:error] = 'You do not have sufficient access rights for invitations'
    respond_to do |format|
      format.html { redirect_to dashboard_path }
      format.any  { head :authorization_failed }
    end
  end

  def load_object_selections
    @friends    = can?(:invite, :anyone) ? User.all : current_user.friends
    @projects   = current_user.projects
  end
end
