class Feedback < ActiveRecord::Base
  belongs_to :domain
  validates_presence_of :note
  
  default_scope :order => 'updated_at DESC' 
end