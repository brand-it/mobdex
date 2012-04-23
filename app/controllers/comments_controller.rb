class CommentsController < ApplicationController
  before_filter :admin_authorized
  
  def create
    @feedback = Feedback.find(params[:feedback_id])
    
    @comment = @feedback.current_user_comment(params, current_user)
    
    if @comment.save
      flash[:success] = "Comment has been created"
    else
      flash[:error] = "Comment could not be craeted" 
    end
    redirect_to admin_domain_feedbacks_path(@feedback.domain)
  end
end