class PublicationNaturesController < BackendController

  def index
    @publication_natures = PublicationNature.order(:name).paginate(:page => params[:page], :per_page => 10)
  end
  
  def new
    @publication_nature = PublicationNature.new()
    respond_to do |format|
      format.html { render_restfully_form(:multipart => true) }
      format.json { render :json => @publication_nature }
      format.xml  { render :xml => @publication_nature }
    end
  end
  
  def create
    @publication_nature = PublicationNature.new(params[:publication_nature])
    respond_to do |format|
      if @publication_nature.save
        format.html { redirect_to (params[:redirect] || publication_natures_url) }
        format.json { render json => @publication_nature, :status => :created, :location => @publication_nature }
      else
        format.html { render_restfully_form(:multipart => true) }
        format.json { render :json => @publication_nature.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @publication_nature = PublicationNature.find(params[:id])
    respond_to do |format|
      format.html { render_restfully_form(:multipart => true) }
    end
  end
  
  def update
    @publication_nature = PublicationNature.find(params[:id])
    respond_to do |format|
      if @publication_nature.update_attributes(params[:publication_nature])
        format.html { redirect_to (params[:redirect] || publication_natures_url) }
        format.json { head :no_content }
      else
        format.html { render_restfully_form(:multipart => true) }
        format.json { render :json => @publication_nature.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @publication_nature = PublicationNature.find(params[:id])
    @publication_nature.destroy
    respond_to do |format|
      format.html { redirect_to (params[:redirect] || publication_natures_url) }
      format.json { head :no_content }
    end
  end

end
