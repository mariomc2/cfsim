class UsersController < ApplicationController
  
  before_action :confirm_logged_in
  before_action :confirm_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  
  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save        
      flash[:notice] = "User was successfully created."
      redirect_to(users_path)
    else
      flash[:notice] = "Error creating user."
      redirect_to(users_path)        
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      flash[:notice] = "User was successfully updated."
      redirect_to(users_path)
    else
      flash[:notice] = "Error updating user."
      redirect_to(users_path) 
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def confirm_admin
      @session_user = User.find(session[:user_id])
      unless @session_user.is_admin        
        redirect_to(projections_path)
        # redirect_to prevents requested action from running
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :username, :password, :is_admin)
    end
end
