class Tagging < ActiveRecord::Base
  belongs_to :domain
  belongs_to :tag
end
