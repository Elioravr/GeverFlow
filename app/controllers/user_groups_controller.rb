class UserGroupsController < ApplicationController
  # GET /user_groups
  # GET /user_groups.json
  def index
    @user_groups = UserGroup.all
    authorize! :see_all, @user_groups

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_groups }
    end
  end

  # GET /user_groups/1
  # GET /user_groups/1.json
  def show
    @user_group = UserGroup.find(params[:id])
    authorize! :watch, @user_group

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_group }
    end
  end

  # GET /user_groups/new
  # GET /user_groups/new.json
  def new
    @user_group = UserGroup.new
    authorize! :create, @user_group

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_group }
    end
  end

  # GET /user_groups/1/edit
  def edit
    @user_group = UserGroup.find(params[:id])
    authorize! :edit, @user_group
  end

  # POST /user_groups
  # POST /user_groups.json
  def create
    @user_group = UserGroup.new(params[:user_group])
    authorize! :create, @user_group

    respond_to do |format|
      if @user_group.save
        format.html { redirect_to @user_group, notice: 'User group was successfully created.' }
        format.json { render json: @user_group, status: :created, location: @user_group }
      else
        format.html { render action: "new" }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_groups/1
  # PUT /user_groups/1.json
  def update
    @user_group = UserGroup.find(params[:id])
    authorize! :update, @user_group

    respond_to do |format|
      if @user_group.update_attributes(params[:user_group])
        format.html { redirect_to @user_group, notice: 'User group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_groups/1
  # DELETE /user_groups/1.json
  def destroy
    @user_group = UserGroup.find(params[:id])
    authorize! :delete, @user_group
    @user_group.destroy

    respond_to do |format|
      format.html { redirect_to user_groups_url }
      format.json { head :no_content }
    end
  end
end
