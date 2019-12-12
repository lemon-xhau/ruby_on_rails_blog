class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def index
    @users = User.select(:id, :name, :email, :is_admin).order(:name)
            .page(params[:page]).per Settings.user.index.per_page
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".welcome"
      redirect_to @user
    else
      flash.now[:danger] = t ".error"
      render "new"
    end
  end

  def edit
     @user = User.find(params[:id])
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".update"
      redirect_to @user
    else
      flash.now[:danger] = t ".error"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = t ".login_first"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
