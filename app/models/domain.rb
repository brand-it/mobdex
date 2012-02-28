class Domain < ActiveRecord::Base
  validates_presence_of :url
  after_validation :build_uri
  after_save :get_data
  
  require 'open-uri'
  require 'nokogiri'
  
  def self.search(search)
    unless search.nil?
      search = scrub_search(search)
      domains = self.where("lower(url) LIKE ? OR lower(description) LIKE ? lower(title) LIKE ?", search, search, search)
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
  
  def build_uri
    # Step one tells me that the uri does have a  http or a https to use
    one = self.url.slice(/(https|http)/)
    if one.nil?
      request_response = "http://"
      uri_split = self.url.split(".")
    else
      request_response = self.url.split("//")[0] + "//"
      uri_split = self.url.split("//")[1].split(".")
    end
    # Step two and three check for the .com and www at the begging. The count is to make sure that is it missing something and not just taking the place of a sub domain.
    if uri_split.count <= 2
      two = self.url.slice(/(com|gov|org|net)/)
      three = self.url.slice(/(www)/)
      # don't add if the thing is there
      if three.nil?
        uri_split.unshift("www")
      end
      if two.nil?
        uri_split << "com"
      end
    end
    
    
    string = uri_split.map{ |split| split }.join(".").to_s
    unless self.url.blank?
      self.url = request_response + string
    end
  end
  
  # This will turn all search information into something that PG can match. More features to be added
  def self.scrub_search(search)
    search = search.downcase
    "%#{search}%"
  end
  
  def get_data
    # The only reason we do this is because we could get a bad url in the system. We are going to try to fix this rather then just redirecting
    begin
      doc = Nokogiri::HTML(open(url))
      self.title = doc.title.to_s
      self.description = doc.xpath("/html/head/meta[@name='description']/@content").to_s
    rescue
      
    end
  end
end