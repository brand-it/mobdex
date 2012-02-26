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
end
