class AdminDomainsController < ApplicationController
  # This will check you access level at tell you if you even should be able to get to this peace of tech
  before_filter :admin_authorized
  # This will overwrite the default layout and use the admin layout
  layout "admin"
  
  def show
  end
  def index
    @domains = Domain.order(:title).page params[:page]
  end
  
  
  def new
    @domain = Domain.new
  end
  
  def edit
    @domain = Domain.find(params[:id])
  end
  
  def update
    @domain = Domain.find(params[:id])

    if @domain.update_attributes(params[:domain])
      flash[:success] = "Domain #{@domain.title} has been updated"
      redirect_to admin_domains_path
    else
      render :action => "edit"
    end
  end
  
  def create
    @domain = Domain.new(params[:domain])
    
    if @domain.save
      flash[:success] = "Domain #{@domain.url} has been created"
      redirect_to admin_domains_path
    else
      flash[:error] = "Domain could not be created do to a error"
      render :action => :new
    end
  end
  
  def destroy
    @domain = Domain.find(params[:id])
    @domain.delete
    
    redirect_to admin_domains_path
  end
  
  def delete_selected
    for domain in params[:domains]
      domain = Domain.find(domain[0])
      domain.delete
    end
    redirect_to admin_domains_path
  end
  
  def update_domain
    domain = Domain.find(params[:id])
    domain.update_domain
    redirect_to admin_domains_path
  end
  
  def update_all
    @status = Domain.update_all_domains
    if @status
      flash[:success] = "All information was successfully updated"
    else
      flash[:error] = "Some of the information could not be updated dew to a error. Please contact admin."
    end
    
    redirect_to admin_domains_path
  end
end