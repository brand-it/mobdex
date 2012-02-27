class Domain < ActiveRecord::Base
  validates_presence_of :name
  
  
  def self.search(search)
    unless search.nil?
      search = scrub_search(search)
      domains = self.where("lower(name) LIKE ?", search)
    else
      domains = self.all
    end
    if domains.blank?
      domains = self.all
    end
    return domains
    # Example
    # @domains = where("lower(name) LIKE ? OR lower(subname) LIKE ? OR lower(description) LIKE ?", search, search, search)
  end
  
  private
  
  # This will turn all search information into something that PG can match. More features to be added
  def self.scrub_search(search)
    search.downcase
    
  end
end