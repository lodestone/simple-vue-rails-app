class UsersController < ApplicationController
  skip_before_filter :require_login, except: [:edit, :update]

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    binding.pry
    if @user.save
      login(params[:user][:email], params[:user][:password])
      redirect_to root_url, notice: 'success'
    else
      render :new
    end
  end

  def activate
    @user = User.load_from_activation_token(params[:id])

    if @user && @user.activate!
      redirect_to login_path, notice: 'Was activated'
    else
      redirect_to root_path, notice: 'Cannot activate user'
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
