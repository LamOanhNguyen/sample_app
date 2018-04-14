class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && password_authenticate?(user)
      log_in user
      params[:session][:remember_me] == Settings.sessions.remember ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = t ".invalid_acc"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end
end
