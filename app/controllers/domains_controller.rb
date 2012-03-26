class DomainsController < ApplicationController
  # before_filter :admin_authorized, :except => [:index, :show, :get_data]
  # layout "admin", :only => [:edit, :create]
  
  def show
    @domain = Domain.find(params[:id])
  end
  
  def index
    @domains, noresults = Domain.search(params[:search], params[:page], request)
    @tags = Tag.all
    if noresults
      flash[:notice] = "I could not find any results. Sorry"
    elsif !params[:search].blank?
      flash[:notice] = "Results found for #{params[:search]}"
    end
  end
  
  def get_data
    @domain = Domain.find(params[:id])
    @data = @domain.fetch_and_save
    render :layout => false
  end
end