class ParametersController < ApplicationController

  def index
    @parameters = Parameter.order("name ASC").paginate(:page => params[:page], :per_page => 10)
  end
  
  def new
    nature = Parameter.natures.detect{|x| x.to_s == params[:nature].to_s}
    @parameter = Parameter.new()
    @parameter.nature = nature
    respond_to do |format|
      format.html { render_restfully_form(:multipart => true) }
      format.json { render :json => @parameter }
      format.xml  { render :xml => @parameter }
    end
  end
  
  def create
    @parameter = Parameter.new(params[:parameter])
    respond_to do |format|
      if @parameter.save
        format.html { redirect_to (params[:redirect] || parameters_url) }
        format.json { render json => @parameter, :status => :created, :location => @parameter }
      else
        format.html { render_restfully_form(:multipart => true) }
        format.json { render :json => @parameter.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @parameter = Parameter.find(params[:id])
    respond_to do |format|
      format.html { render_restfully_form(:multipart => true) }
    end
  end
  
  def update
    @parameter = Parameter.find(params[:id])
    respond_to do |format|
      if @parameter.update_attributes(params[:parameter])
        format.html { redirect_to (params[:redirect] || parameters_url) }
        format.json { head :no_content }
      else
        format.html { render_restfully_form(:multipart => true) }
        format.json { render :json => @parameter.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @parameter = Parameter.find(params[:id])
    @parameter.destroy
    respond_to do |format|
      format.html { redirect_to (params[:redirect] || parameters_url) }
      format.json { head :no_content }
    end
  end

end
