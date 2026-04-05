class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:name].downcase)
   
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to items_path, notice: "Welcome back, #{user.name}! ✨"
    else
      redirect_to login_path, alert: "Invalid name or password! Please enter again."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "You have been logged out. See you soon! 👋"
  end
end