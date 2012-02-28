class Domain < ActiveRecord::Base
  validates_presence_of :url
  before_create :get_data
  
  require 'open-uri'
  require 'nokogiri'
  
  def self.search(search)
    unless search.nil?
      search = scrub_search(search)
      domains = self.where("lower(url) LIKE ?", search)
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
    search = search.downcase
    "%#{search}%"
  end
  
  def get_data
    doc = Nokogiri::HTML(open(url))
    self.title = doc.title.to_s
    self.description = doc.xpath("/html/head/meta[@name='description']/@content").to_s
  end
end