class UsersController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]
  before_action :set_user, only: %i[show edit update destroy]
  before_action :admin!, only: [:index]
  # before_action :last_admin!, only: [:destroy]

  # GET /users or /users.json
  def index
    @users = User.includes(:tasks)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /admin/new
  def new_by_admin
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.valid?
        @user.save
        session[:user_id] = @user.id
        format.html { redirect_to root_path, notice: t('forms.create.signup_success') }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_by_admin
    @user = User.new(user_params)
    respond_to do |format|
      if @user.valid?
        @user.save
        format.html { redirect_to admin_path, notice: t('forms.create.signup_success')}
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: t('forms.edit.success') }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    respond_to do |format|
    #   format.html { redirect_to users_url, notice: t('forms.delete.success') }
    #   format.json { head :no_content }
    # end
      if @user.destroy
        format.html { redirect_to admin_path, notice: t('forms.delete.success') }
        format.json { head :no_content }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end
  
  private

  # def last_admin!
  #   if User.where(:admin => true).count == 1 && @user.admin?
  #     redirect_to admin_path, notice: t('forms.last_admin')
  #   end
  # end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :password)
  end
  
  def admin!
    unless current_user && current_user.admin?
      redirect_to root_path, notice: t('forms.not_admin')
    end
  end

  
end
