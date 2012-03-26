class MassDomain < ActiveRecord::Base
  validates_presence_of :domains
  
  def add_domains
    # if self.domains.nil?
    # puts self.domains.to_s
    if self.parse_type == 1
      domains_array = self.domains.split(",")
    else
      # If all else fails it will try to split the data based off of spaces
      domains_array = self.domains.split
    end
    errors = ""
    for domain in domains_array
      new_domain = Domain.new(:mobile_url => domain.to_s)
      unless new_domain.save
        errors += new_domain.errors.full_messages.map{|msg| new_domain.mobile_url + " " + msg.to_s}.join("</br>")
      else
        new_domain.fetch_and_save
      end
    end
    if errors.blank?
      error = false
    else
      error = true
    end
    self.update_attributes(:error_message => errors, :error => error, :added_on => Time.now, :added => true )
  end
  
  def reset_information
    self.added = false
    self.added_on = nil
    self.error = false
    self.error_message = nil
    # It needs these beacuse the last value in the list is false. In result it returns false
    true
  end

end