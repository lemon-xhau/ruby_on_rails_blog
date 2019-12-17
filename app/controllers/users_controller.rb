class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
     @users = User.paginate(page: params[:page])
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

  def destroy
    if @user.destroy
      flash[:success] = t ".delete_done"
      redirect_to users_url
    else
      flash[:danger] = t ".delete_failed"
      redirect_back fallback_location: root_path
    end
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

  def admin_user
    redirect_to root_url unless current_user.is_admin?
  end
end
