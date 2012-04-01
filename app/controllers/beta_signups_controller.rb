class BetaSignupsController < ApplicationController
  layout "admin", :only => :index 
  def index
    @beta_signups = BetaSignup.order(:created_at).page params[:page]
  end
  def new
    @beta_signup = BetaSignup.new
  end
  
  def create
    @beta_signup = BetaSignup.new(params[:beta_signup])
    
    if @beta_signup.save
      flash[:success] = "You have successful signup for beta."
      BetaSignupEmails.congratulate(@beta_signup).deliver
      redirect_to root_path
    else
      flash[:error] = "Sorry could not sign you up dew to a invalid email."
      render :action => :new
    end
  end
end