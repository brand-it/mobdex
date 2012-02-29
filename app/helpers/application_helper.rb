module ApplicationHelper
  
  def errors(object)
    render "layouts/errors", :object => object
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
end
