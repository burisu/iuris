class UsersController < BackendController
  skip_before_filter :check_fields!, :only => [:edit, :update]

  def index
    unless current_user.administrator?
      redirect_to root_url
      return
    end
    @users = User.order(:last_name, :first_name).paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new()
    respond_to do |format|
      format.html { render_restfully_form }
      format.json { render :json => @user }
      format.xml  { render :xml => @user }
    end
  end
  
  def create
    unless current_user.administrator?
      head :forbidden
      return
    end
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to (params[:redirect] || users_url) }
        format.json { render json => @user, :status => :created, :location => @user }
      else
        format.html { render_restfully_form }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @user = User.find(params[:id])
    unless current_user.administrator? or current_user.id == @user.id
      head :forbidden
      return
    end
    respond_to do |format|
      format.html { render_restfully_form }
    end
  end
  
  def update
    @user = User.find(params[:id])
    unless current_user.administrator? or current_user.id == @user.id
      head :forbidden
      return
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to (params[:redirect] || users_url) }
        format.json { head :no_content }
      else
        format.html { render_restfully_form }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    unless current_user.administrator?
      head :forbidden
      return
    end
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to (params[:redirect] || users_url) }
      format.json { head :no_content }
    end
  end

  def deactivate
    @user = User.find(params[:id])
    @user.deactivate!
    respond_to do |format|
      format.html { redirect_to (params[:redirect] || users_url) }
      format.json { head :no_content }
    end
  end

  def activate
    @user = User.find(params[:id])
    @user.activate!
    respond_to do |format|
      format.html { redirect_to (params[:redirect] || users_url) }
      format.json { head :no_content }
    end
  end

end
