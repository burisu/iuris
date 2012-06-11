class LabelsController < ApplicationController

  def index
    @labels = Label.order("name ASC").paginate(:page => params[:page], :per_page => 10)
  end
  
  def new
    @label = Label.new()
    respond_to do |format|
      format.html { render_restfully_form }
      format.json { render :json => @label }
      format.xml  { render :xml => @label }
    end
  end
  
  def create
    @label = Label.new(params[:label])
    respond_to do |format|
      if @label.save
        format.html { redirect_to (params[:redirect] || labels_url) }
        format.json { render json => @label, :status => :created, :location => @label }
      else
        format.html { render_restfully_form }
        format.json { render :json => @label.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @label = Label.find(params[:id])
    respond_to do |format|
      format.html { render_restfully_form }
    end
  end
  
  def update
    @label = Label.find(params[:id])
    respond_to do |format|
      if @label.update_attributes(params[:label])
        format.html { redirect_to (params[:redirect] || labels_url) }
        format.json { head :no_content }
      else
        format.html { render_restfully_form }
        format.json { render :json => @label.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @label = Label.find(params[:id])
    @label.destroy
    respond_to do |format|
      format.html { redirect_to (params[:redirect] || labels_url) }
      format.json { head :no_content }
    end
  end


end
