class Feedback < ActiveRecord::Base
  belongs_to :domain
  validates_presence_of :note 
end