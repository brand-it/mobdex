class DomainsController < ApplicationController
  # before_filter :admin_authorized, :except => [:index, :show, :get_data]
  # layout "admin", :only => [:edit, :create]
  
  def show
    @domain = Domain.find(params[:id])
  end
  
  def index
    @domains, noresults = Domain.search(params[:search])
    @tags = Tag.all
    if noresults
      flash[:notice] = "I could not find any results. Sorry"
    else
      # We do this because flash will some times keep the data for more the one request
      flash[:notice] = nil
    end
  end
  
  def get_data
    @domain = Domain.find(params[:id])
    render :layout => false
  end
end