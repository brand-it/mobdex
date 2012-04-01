class Feedback < ActiveRecord::Base
  belongs_to :domain
  validates_presence_of :note
  
  default_scope :order => 'updated_at DESC' 
  
  has_many :comments
  
  def current_user_comment(params, current_user)
    feedback = Feedback.find(params[:feedback_id])
    comment = feedback.comments.build(params[:comment])
    comment.set_user_id(current_user)
    return comment
  end
end