class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:user_name, :password)
    puts "user_params #{user_params}"
    @user = User.confirm(user_params)
    if @user
      login (@user)
      flash[:notice]="Successfully logged in."
      redirect_to @user
    else
      puts @user.errors.messages
      flash[:error] = "Incorrect username or password."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id]= nil
    logout
    flash[:notice] = "Successfully logged out."
    redirect_to root_path
  end
end
