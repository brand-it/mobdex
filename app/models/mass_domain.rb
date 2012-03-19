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
        new_domain = Domain.new(:url => domain.to_s, :mobile_url => domain.to_s)
        unless new_domain.save
          errors += "Domain #{domain} could not be added"
        end
      end
      if errors.blank?
        error = false
      else
        error = true
      end
      self.update_attributes(:error_message => errors, :error => error, :added_on => Time.now, :added => true )
    end
  # end
end