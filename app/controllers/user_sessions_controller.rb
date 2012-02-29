class UserSessionsController < ApplicationController
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:success] = "Login successful!"
      redirect_to root_path
    else
      flash[:error] = "Sorry could not login you in. Your email password or you have not clicked the link in email yet."
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:success] = "Logout successful!"
    redirect_to root_path
  end
end