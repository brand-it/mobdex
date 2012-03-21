class Domain < ActiveRecord::Base
  require 'open-uri'
  require 'nokogiri'
  require "net/http"
  require "uri"
  
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings, :dependent => :destroy
  # We are not going to use this anymore because if its blank we are going to have the mobile url build it for use.
  # validates_presence_of :url
  validates_presence_of :mobile_url
  validates_uniqueness_of :mobile_url
  validates_uniqueness_of :url
  
  before_validation :clean_urls
  before_save :get_data
  before_update :get_data
  after_save :assign_tags
  
  attr_writer :tag_names
  
  def favicon_url
    if self.favicon_path.slice(/(https|http)/).nil?
      self.url + "/" + self.favicon_path
    else
      self.favicon_path
    end
  end
  
  # There are only two request types I can think of right now
  def url_request_type
    url.slice(/(https|http)/)
  end
  
  # Used for the forms
  def tag_names
     @tag_names || tags.map(&:name).join(',')
  end
   
  # This is the search system every search should use this.
  def self.search(search, page_number) 
    norsults = false
    unless search.nil?
      search = scrub_search(search)
      domains = self.page(page_number).where(search).includes(:tags)
    end
    if domains.blank?
      domains = self.order(:title).page(page_number)
      noresults = true unless search.nil?
    end
    return domains, noresults
  end
  
  # Admin should only call this method check make sure of this in controller
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
  
  def fetch(url_string = nil, limit = 10)
    # You should choose better exception.
    # raise ArgumentError, 'HTTP redirect too deep stoped at ' + url if limit == 0
    url_string = self.url if url_string.nil?
    uri = URI.parse(url_string + "/")
    # Shortcut
    http = Net::HTTP.new(uri.host, uri.port)
    
    if url_string.slice(/(https|http)/) == "https"
      http.use_ssl = true
    else
      http.use_ssl = false
    end
    begin
      response = http.request(Net::HTTP::Get.new(uri.request_uri))
    rescue
      # Something really hit the fan
      return false
    end
    
    if limit != 0
      case response
      when Net::HTTPSuccess   then response
      when Net::HTTPRedirection then fetch(response['location'], limit - 1)
      when Net::HTTPServiceUnavailable then fetch(url_string, limit - 1)
      else
        response
      end
    else
      return response
    end
  end
  
  private
  
  def get_data
    response = fetch
    if response 
      if response.header.code == "200"
        doc = Nokogiri::HTML(response.body)
        self.title = doc.title.to_s
        content_description = doc.xpath("//meta[@name='description']/@content")
        # Some people use the wrong capitlization
        if content_description.blank?
          content_description = doc.xpath("/html/head/meta[@name='Description']/@content")
        end
        unless content_description.blank?
          self.description = content_description.to_s
        end
        content_keywords = doc.xpath("//meta[@name='keywords']/@content").to_s
        if content_keywords.blank?
          content_keywords = doc.xpath("//meta[@name='Keywords']/@content").to_s
        end
        
        self.tag_names += "," + content_keywords
        self.data_recived_on = Time.now
      end
      self.code = response.header.code.to_i
    else
      self.code = 502
    end
  end
  
  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(",").map do |name|
        Tag.find_or_create_by_name(name.downcase)
      end
    end
  end
  
  def clean_urls
    # You need to build the mobile url first
    self.mobile_url = build_url(self.mobile_url)
    if self.url.blank?
      self.url = build_url_from_mobile
    else
      self.url = build_url(self.url)
    end
  end
  
  def build_url_from_mobile
    mobile_array = self.mobile_url.split("//")[1].split("/")[0].split(".")
    build_url(mobile_array[mobile_array.length - 2].to_s + "." + mobile_array[mobile_array.length - 1].to_s)
  end
  
  # This will turn any string that is passed into into a url
  def build_url(url)
    # this will remove any of the blank spaces. There is no reason for blank space in the url or brake lines
    url = url.gsub(" ", "").gsub(/\n/, "").gsub(/\r/, "")
    
    
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
      two = url.slice(/(com|gov|org|net|mobi)/)
      three = url.slice(/(www)/)
      # don't add if the thing is there
      if three.nil?
        uri_split.unshift("www")
      end
      if two.nil?
        uri_split << "com"
      end
    end
    
    
    path_seperator = uri_split[uri_split.length - 1].split(/\//)
    if path_seperator && path_seperator.length <= 1
      uri_split[uri_split.length - 1] = path_seperator
    end
    
    
   
    string = uri_split.map{ |split| split }.join(".").to_s
    # I can't figure this part out but it sucks
    path_thing = string.split(/\//) 
    unless url.blank?
      url = request_response + string
    end
  end
  
  # This will turn all search information into something that PG can match
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