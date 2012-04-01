class FeedbacksController < ApplicationController
  layout "admin"
  
  
  def show
    @domain = Domain.find(params[:admin_domain_id])
    @feedback = Feedback.find(params[:id])
  end
  
  def index
    @domain = Domain.find(params[:admin_domain_id])
    @feedbacks = @domain.feedbacks
  end
  def new
    @domain = Domain.find(params[:admin_domain_id])
    @feedback = Feedback.new
  end
  
  def create
    @domain = Domain.find(params[:admin_domain_id])
    @feedback = @domain.feedbacks.build(params[:feedback])
    if @feedback.save
      flash[:success] = "Added new feedback to the domain"
      redirect_to admin_domain_feedbacks_path(@domain)
    else
      flash[:error] =  "Feedback could not be added dew to a error"
      render :action => :new
    end
  end
end
