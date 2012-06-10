class AnswersController < ApplicationController

  def index
    @answers = Answer.paginate(:page => params[:page], :per_page => 25)
  end

  def show
    @answer = Answer.find(params[:id])
    session[:current_answer_id] = @answer.id
  end
  
  def new
    @answer = Answer.new()
    respond_to do |format|
      format.html { render_restfully_form }
      format.json { render :json => @answer }
      format.xml  { render :xml => @answer }
    end
  end
  
  def create
    @answer = Answer.new(params[:answer])
    @answer.author = current_user
    @answer.question = Question.find(params[:question_id])
    respond_to do |format|
      if @answer.save
        format.html { redirect_to (params[:redirect] || question_url(@answer.question)) }
        format.json { render json => @answer, :status => :created, :location => @answer }
      else
        format.html { render_restfully_form }
        format.json { render :json => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @answer = Answer.find(params[:id])
    respond_to do |format|
      format.html { render_restfully_form }
    end
  end
  
  def update
    @answer = Answer.find(params[:id])
    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.html { redirect_to (params[:redirect] || question_url(@answer.question)) }
        format.json { head :no_content }
      else
        format.html { render_restfully_form }
        format.json { render :json => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to (params[:redirect] || question_url(@answer.question)) }
      format.json { head :no_content }
    end
  end

end
