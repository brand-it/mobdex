class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  before_filter :admin_authorized, :only =>  :index
  
  def index
    @users = User.all
    store_location
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.create_user(params[:user])
    if @user
      ValidateEmails.send_validation(@user).deliver
      flash[:notice] = "Account registered and email has been sent to your account!"
      redirect_to root_path
    else
      flash[:error] = "Your account could not be created."
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end

  def edit
    if admin_authorized(:ignore_redirect => true, :ignore_flash => true)
      @user = User.find(params[:id])
    else
      @user = @current_user
    end
  end
  
  def update
    if admin_authorized(:ignore_redirect => true, :ignore_flash => true)
      @user = User.find(params[:id])
    else
      @user = @current_user
    end
    if @user.update_user(current_user, params[:user])
      flash[:notice] = "Account updated!"
      redirect_to back_or_default
    else
      render :action => :edit
    end
  end
  
  
  
  # If your activation did not send for some reason you can ask for it to be sent again.
  def request_activation
    @user = User.new
  end
  
  # This is for if there was a problem with the activation and for some reason the email link they go was screwed ups
  def resend_activation
    @user = User.find_by_email(params[:user][:email])
    if @user
      flash[:success] = "Your Acitivation has been sent to #{@user.email}"
      ValidateEmails.send_validation(@user).deliver
      redirect_to back_or_default
    else
      flash[:error] = "Sorry could not send you a email to #{params[:user][:email]}"
      redirect_to request_activation_users_path
    end
  end
  
  def activate
    @user = User.find_and_activate_user(params[:perishable_token])
    
    if @user
      flash[:success] = "Your account has been activated!"
      redirect_to login_path
    else
      flash[:error] = "Could not activate your account."
      redirect_to request_activation_users_path
    end
  end
end