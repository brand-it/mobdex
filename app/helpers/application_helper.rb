module ApplicationHelper
  
  def logged_in?
    if current_user.nil?
      return false
    else
      return true
    end
  end
  
  def admin_errors(object)
    render "layouts/admin_errors", :object => object
  end
  
  def errors(object)
    render "layouts/errors", :object => object
  end
  
  def flash? 
    if flash_notifier.blank?
      return false
    else
      return true
    end
  end
  
  def flash_notifier
    if flash[:error]
      notice = content_tag(:p, flash[:error], :class => "error-message")
    end
    if flash[:notice]
      notice = content_tag(:p, flash[:notice], :class => "notice-message")
  	end
  	if flash[:success]
  	  notice = content_tag(:p, flash[:success], :class => "success-message")
	  end
  	return notice
  end
  
  def truncate_short(text)
    truncate(text, :length => 20)
  end
  
  # A nice way to help the views tell if you are on the current page you want to be on.
  def current_view(params, options = {})
    valid = true
    
    results = options[:result]

    options.each do |option|
      for param in params
        if param[0].to_s == option[0].to_s
          unless param[1].to_s == option[1].to_s 
            valid = false
          end
        end
        if options[:ignore]
          options[:ignore].each do |ignore|
            if param[0].to_s == ignore[0].to_s && param[1].to_s == ignore[1].to_s
              valid = false
            elsif ignore[0].to_s == param[0].to_s && ignore[1].to_s == "all"
              valid = false
            end
          end
        end
      end
    end
    if results.blank?
      return valid
    elsif valid
      return results
    end
  end
  
  # There is a built in method but it has some problems so we are going use one I built
  def textilize(text, *options)
    options ||= [:hard_breaks]

    if text.blank?
      ""
    else
      textilized = RedCloth.new(text, options)
      textilized.to_html.html_safe
    end
  end
end
