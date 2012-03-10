class Domain < ActiveRecord::Base
  require 'open-uri'
  require 'nokogiri'
  
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings, :dependent => :destroy
  
  validates_presence_of :url
  validates_presence_of :mobile_url
  
  after_validation :clean_urls
  before_save :get_data
  before_update :get_data
  after_save :assign_tags
  
  attr_writer :tag_names
  
  
  def request_type
    url.slice(/(https|http)/)
  end
  
  def tag_names
     @tag_names || tags.map(&:name).join(' ')
  end
   
  def self.search(search)
    norsults = false
    unless search.nil?
      search = scrub_search(search)
      domains = self.find(:all,:conditions => search, :include => :tags)
    else
      domains = self.all
    end
    if domains.blank?
      domains = self.all
      noresults = true
    end
    return domains, noresults
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
    doc = Nokogiri::HTML(open(url))
    self.title = doc.title.to_s
    self.description = doc.xpath("/html/head/meta[@name='description']/@content").to_s
    self.data_recived_on = Time.now
  end
  
  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/\s+/).map do |name|
        Tag.find_or_create_by_name(name.downcase)
      end
    end
  end
  
  def clean_urls
    self.url = build_url(self.url)
    self.mobile_url = build_url(self.mobile_url)
  end
  
  # This will turn any string that is passed into into a url
  def build_url(url)
    # Step one tells me that the uri does have a  http or a https to use
    one = url.slice(/(https|http)/)
    if one.nil?
      request_response = "http://"
      uri_split = url.split(".")
    else
      request_response = url.split("//")[0] + "//"
      uri_split = url.split("//")[1].split(".")
    end
    # Step two and three check for the .com and www at the begging. The count is to make sure that is it missing something and not just taking the place of a sub domain.
    if uri_split.count <= 2
      two = url.slice(/(com|gov|org|net)/)
      three = url.slice(/(www)/)
      # don't add if the thing is there
      if three.nil?
        uri_split.unshift("www")
      end
      if two.nil?
        uri_split << "com"
      end
    end
    
    
    string = uri_split.map{ |split| split }.join(".").to_s
    unless url.blank?
      url = request_response + string
    end
  end
  
  # This will turn all search information into something that PG can match. More features to be added
  def self.scrub_search(search)
    split_search = search.downcase.split(" ")
    
    url_array = Array.new
    title_array = Array.new
    description_array = Array.new
    tag_array = Array.new
    
    for split in split_search
      url_array << "lower(url) LIKE '%#{split}%'"
      description_array << "lower(description) LIKE '%#{split}%'"
      title_array << "lower(title) LIKE '%#{split}%'"
      tag_array << "lower(tags.name) LIKE '%#{split}%'"
    end
    # You can only join a array however we do not want to add data to a array that is nil
    array_string = Array.new
    
    # Turn this into a method becoming to complicated to be here
    url_string = url_array.map{ |search| search }.join(" AND ").to_s
    array_string << url_string unless url_string.blank?
    
    description_string = description_array.map{ |search| search }.join(" AND ").to_s
    array_string << description_string unless description_string.blank?
    
    title_string = title_array.map{ |search| search }.join(" AND ").to_s
    array_string << title_string unless title_string.blank?
    
    tag_string = tag_array.map{ |search| search }.join(" AND ").to_s
    array_string << tag_string unless tag_string.blank?
    
    return array_string.map{|build| build}.join(" OR ").to_s
  end
end