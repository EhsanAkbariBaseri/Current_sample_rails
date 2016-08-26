class UsersController < ApplicationController

  before_action :logged_in_user,only: [:edit,:update,:index,:delete]
  before_action :correct_user, only: [:edit,:update]
  before_action :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
    (redirect_to root_url and return) unless @user.activated?
  end

  def index
    @users = User.where(activated:true).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "User deleted successfully"
    redirect_to users_url
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "This page is available to logged in users only. In order to access this page please log in or sign up."
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
