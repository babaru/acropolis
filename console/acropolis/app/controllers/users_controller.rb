class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users_grid = initialize_grid(User.all)
  end

  # GET /users/1
  # GET /users/1.json
  def show
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
    User.transaction do
      @user = User.new(user_params)
      @user.save!
    end

    respond_to do |format|
      set_users_grid
      format.html { redirect_to @user, notice: 'User was successfully created.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.js { render :new }
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    User.transaction do
      @user.update!(user_params)
    end

    respond_to do |format|
      set_users_grid
      format.html { redirect_to @user, notice: 'User was successfully updated.'}
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :edit }
      format.js { render :edit }
    end
  end

  def delete
    @user = User.find(params[:user_id])
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      set_users_grid
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.js
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :delete }
      format.js { render :delete }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      params.require(:user).permit(
        :email,
        :password,
        :password_confirmation,
        :encrypted_password,
        :reset_password_token,
        :reset_password_sent_at,
        :remember_created_at,
        :sign_in_count,
        :current_sign_in_at,
        :last_sign_in_at,
        :current_sign_in_ip,
        :last_sign_in_ip,
        :name,
        :full_name,
        :avatar_file_name,
        :avatar_content_type,
        :avatar_file_size,
        :avatar_updated_at,
        :attachment_access_token,
        )
    end

    def set_users_grid
      @users_grid = initialize_grid(User)
    end
end

