class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update,:destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user ,    only: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # Handle a successful save.
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    # @user = current_user# why not current_user?
    # same effect, but the Spec test will not pass since it does not start from log in
    # secondly, @user= User.find(params[:id]) may not be equal to the user logged in!!!
  end

  def update
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  def confirm_destroy
    @user=User.find(params[:id])
  end

  private
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end
