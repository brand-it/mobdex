class User < ActiveRecord::Base
  acts_as_authentic
  
  # Use the data to activate the account
  def self.find_and_activate_user(perishable_token)
    user = find_by_perishable_token(perishable_token)
    if user
      user.active = true
      return user.save
    else
      return false
    end
  end
  
  def self.for_select
    users = self.find_admin_clients
    users.collect {|u| [ u.full_name, u.id ] }
  end

  def self.new_user_safe_mode(params)
    user = self.new(params)
    user.access_level = 1
    return user
  end
  
  def update_user(current_user, params_user)
    if current_user.access_level != 8
      params_user[:access_level] = current_user.access_level
    end
    return update_attributes(params_user)
  end
  
  def full_name
    unless first_name.nil? && last_name.nil?
      [first_name,last_name].join(' ').titleize
    else
      return nil
    end
  end
end