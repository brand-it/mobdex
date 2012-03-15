class ApplicationController < ActionController::Base
  
  protect_from_forgery
  helper_method :current_user_session, :current_user
  
  before_filter :prepare_for_mobile
  
  # Failed authorization should all ways come before the return. Makes sure that the test
  # and the views are redirected before they are returned false.
  def correct_user(account_id, options = {})
    if !current_user.nil?
      if current_user.id == account_id || admin_authorized(:ignore_redirect => true, :ignore_flash => true)
        return true
      else
        failed_authorization(options)
        return false
      end
    else
      failed_authorization(options)
      return false
    end
  end
  
  # Access level numbers are 1, 2, 4, 8
  # All permutations are currently being calculated in the Application Helper
  # May need to come up with a better means of calculating that.
  # User_type_one access level is 1
  # Had to use _authorized because job has a method called user_type_one
  def basic_authorized(options = {})
    authorization([basic, collaborator, admin], options)
  end
  
  # User_type_two access level is 2
  def client_authorized(options = {})
    authorization([client, collaborator, admin], options)
  end
  
  # User_type_three access level is 4
  def collaborator_authorized(options = {})
    # Access should only let the user create jobs and user type two
    authorization([collaborator, admin], options)
  end
  
  # User_type_four access level is 8
  def admin_authorized(options = {})
    auth = authorization([admin], options)
  end
  
  def store_location
    session[:return_to] = request.fullpath if request.get?
  end

  def back_or_default
    session[:return_to] || root_path
  end
  
  # Note this code can be made to infinite loop don't I mean don't screw this up
  # def fetch(uri_str, limit = 10)
  #   # You should choose better exception.
  #   raise ArgumentError, 'HTTP redirect too deep' if limit == 0
  # 
  #   uri = URI.parse(uri_str + "/")
  #   # Shortcut
  #   response = Net::HTTP.get_response(uri)
  #   
  #   case response
  #   when Net::HTTPForbidden then response
  #   when Net::HTTPNotFound then response
  #   when Net::HTTPSuccess   then response
  #   when Net::HTTPRedirection then fetch(response['location'], limit - 1)
  #   else
  #     response.error!
  #   end
  # end
  
  # def ssl_fetch(uri_str, limit = 10)
  #   # You should choose better exception.
  #   raise ArgumentError, 'HTTP redirect too deep' if limit == 0
  # 
  #   uri = URI.parse(uri_str + "/")
  #   # Shortcut
  #   http = Net::HTTP.new(uri.host, uri.port)
  #   http.use_ssl = true
  #   
  #   request = Net::HTTP::Get.new(uri.request_uri)
  #   response = http.request(request)
  #   
  #   case response
  #   when Net::HTTPForbidden then response
  #   when Net::HTTPNotFound then response
  #   when Net::HTTPSuccess   then response
  #   when Net::HTTPRedirection then fetch(response['location'], limit - 1)
  #   else
  #     response.error!
  #   end
  # end
  
  # def check_status(uri_str, code)
  #   response = fetch(uri_str)
  #   if response.code.to_i == code
  #     true
  #   else
  #     false
  #   end
  # end
  
  private 
  
  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end
  
  def basic
    return 1
  end
  def client
    return 2
  end
  def collaborator
    return 4
  end
  def admin
    return 8
  end
  
  # Admin should be able to do every thing. No mater what it is.
  # Need to pass an array into this in order for it to work.
  def authorization(levels, options = {})
    granted = false
    for level in levels
      if current_user and current_user.access_level == level
        granted = true
      end
    end

    if granted
      return granted
    else
      failed_authorization(options)
      return granted
    end
  end
  
  # Change this in order to change were the user is redirected if he does not have access to page.
  def failed_authorization(options = {})
    unless options[:ignore_flash]
      flash[:error] = options[:flash_error] || "You do not have access to this page. Please Login to a user that does."
    end
    unless options[:ignore_redirect] == true
      redirect_to login_path
    end
  end
  
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  

  def require_user
    unless current_user
      store_location
      flash[:error] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:error] = "You must be logged out to access this page"
      redirect_to login_path
      return false
    end
  end
end
