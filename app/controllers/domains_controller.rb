class DomainsController < ApplicationController

  
  def show
    @domain = Domain.find(params[:id])
    
    @doc = Nokogiri::Slop(open(@domain.url))
  end
  def index
    @domains = Domain.search(params[:search])
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
      redirect_to domains_path
    else
      render :action => "edit"
    end
  end
  
  def create
    @domain = Domain.new(params[:domain])
    
    if @domain.save
      flash[:success] = "Domain #{@domain.url} has been created"
      redirect_to domains_path
    else
      flash[:error] = "Domain could not be created do to a error"
      render :action => :new
    end
    
  end
  def destory
  end
end