module AdminHelper
  def flash_notifier_admin
    if flash[:error]
      render "flashes/admin_error"
    elsif flash[:notice]
      render "flash/admin_notice"
  	elsif flash[:success]
  	  render "flashes/admin_success"
	  else
	    render "flashes/admin_success"
      # render "layouts/errors", :object => object
	  end
  end
end