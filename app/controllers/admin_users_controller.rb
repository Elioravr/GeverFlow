class AdminUsersController < ApplicationController
  # GET /admin_users
  # GET /admin_users.json
  def index
    @users = User.all
    authorize! :see_all, @users

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end
  
  # GET /admin_users/1
  # GET /admin_users/1.json
  def show
    @user = User.find(params[:id])
    authorize! :watch, @user

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /admin_users/new
  # GET /admin_users/new.json
  def new
    @user = User.new
    authorize! :create, @user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /admin_users/1/edit
  def edit
    @user = User.find(params[:id])
    authorize! :edit, @user
  end

  # POST /admin_users
  # POST /admin_users.json
  def create
    @user = User.new(params[:user])
    authorize! :create, @user

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        debugger
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /admin_users/1
  # PUT /admin_users/1.json
  def update
    @user = User.find(params[:id])
    authorize! :update, @user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to admin_users_path, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_users/1
  # DELETE /admin_users/1.json
  def destroy
    @user = User.find(params[:id])
    authorize! :delete, @user
    @user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end
end
