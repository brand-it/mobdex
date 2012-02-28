class Domain < ActiveRecord::Base
  require 'open-uri'
  require 'nokogiri'
  
  validates_presence_of :url
  validates_presence_of :mobile_url
  after_validation :build_uri
  before_save :get_data
  before_update :get_data
  

  
  def self.search(search)
    
    unless search.nil?
      search = scrub_search(search)
      domains = self.find(:all,:conditions => search)
    else
      domains = self.all
    end
    if domains.blank?
      domains = self.all
    end
    return domains
  end
  
  def self.update_all_domains
    domains = self.all
    success = true
    for domain in domains
      unless domain.save
        success = false
      end
    end
    return success
  end
  
  private
  
  def get_data
    # The only reason we do this is because we could get a bad url in the system. We are going to try to fix this rather then just redirecting
    begin
      doc = Nokogiri::HTML(open(url))
      self.title = doc.title.to_s
      self.description = doc.xpath("/html/head/meta[@name='description']/@content").to_s
      self.data_recived_on = Time.now
    rescue
    ensure
    end
  end
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
    split_search = search.downcase.split(" ")
    
    url_array = Array.new
    title_array = Array.new
    description_array = Array.new
    
    for split in split_search
      url_array << "lower(url) LIKE '%#{split}%'"
      description_array << "lower(description) LIKE '%#{split}%'"
      title_array << "lower(title) LIKE '%#{split}%'"
    end
    
    url_string = "#{url_array.map{ |search| search }.join(" OR ").to_s}"
    description_string = "#{description_array.map{ |search| search }.join(" OR ").to_s}"
    title_string = "#{title_array.map{ |search| search }.join(" OR ").to_s}"
    
    return url_string + " OR " + description_string + " OR " + title_string
  end
end