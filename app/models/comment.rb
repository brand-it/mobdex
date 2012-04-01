class Comment < ActiveRecord::Base
  validates_presence_of :feedback
  belongs_to :created_by_user, :foreign_key => :created_by, :class_name => User
  belongs_to :feedback
  
  default_scope :order => 'created_at DESC' 
  
  def set_user_id(current_user)
    unless current_user.nil?
  	  self.created_by = current_user.id
    end
  end
end
