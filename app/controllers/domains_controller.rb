class DomainsController < ApplicationController
  def show
    @domain = Domain.find(params[:id])
  end
  def index
    @domains = Domain.search(params[:search])
  end
  def new
    @domain = Domain.new
  end
  def create
    @domain = Domain.new(params[:domain])
    
    if @domain.save
      flash[:success] = "Domain #{@domain.name} has been created"
      redirect_to domains_path
    else
      flash[:error] = "Domain could not be created do to a error"
      render :action => :new
    end
    
  end
  def destory
  end
end