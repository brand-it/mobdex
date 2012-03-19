class MassDomainsController < ApplicationController
  # This will check you access level at tell you if you even should be able to get to this peace of tech
  before_filter :admin_authorized
  # This will overwrite the default layout and use the admin layout
  layout "admin"
  
  def new
    @mass_domain = MassDomain.new
  end
  def create
    @mass_domain = MassDomain.new(params[:mass_domain])
    if @mass_domain.save
      flash[:succss] = "Domains have been added to the site"
      redirect_to mass_domains_path
    else
      flash[:error] = "Domains could not be added dew to a error"
      render :action => :new
    end
  end
  
  def index
    @mass_domains = MassDomain.all(:order => "updated_at DESC")
  end
  def edit
    @mass_domain = MassDomain.find(params[:id])
  end
  
  def update
    @mass_domain = MassDomain.find(params[:id])
    params[:mass_domain][:added] = false
    params[:mass_domain][:added_on] = nil
    if @mass_domain.update_attributes(params[:mass_domain])
      flash[:success] = "Bulk Domains has been updated"
      redirect_to mass_domains_path
    else
      flash[:error] = "Bulk Could not be updated dew to a error"
      render :action => "edit"
    end
  end
  
  def show
    @mass_domain = MassDomain.find(params[:id])
  end
  def destroy
    @mass_domain = MassDomain.find(params[:id])
    @mass_domain.delete
    flash[:notice] = "Bulk Bomain has been deleted."
    redirect_to mass_domains_path
  end
  def add_domains
    mass_domain = MassDomain.find(params[:id])
    mass_domain.add_domains
    flash[:success] = "Domains have been added"
    redirect_to mass_domains_path
  end
end