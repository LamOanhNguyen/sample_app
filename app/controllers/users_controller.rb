class UsersController < ApplicationController
  before_action :load_user, only: %i(edit update show correct_user)
  before_action :logged_in_user, only: %i(index edit update destroy show)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  def index
    @users = User.paginate page: params[:page], per_page: Settings.user.number_items_per_page
  end

  def show
    if @user.blank?
      redirect_to signup_path
    else
      render :show
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @user = User.find_by id: params[:id]
  end

  def update
    if @user.update user_params
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = I18n.t ".users.index.success_msg"
    else
      flash[:danger] = I18n.t ".users.index.error_msg"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = I18n.t "users.new.please_log_in."
      store_location
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user.present?
    flash[:danger] = t ".not_find_user"
    redirect_to root_url
  end
end
