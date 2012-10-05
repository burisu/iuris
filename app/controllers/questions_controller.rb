# -*- coding: utf-8 -*-
class QuestionsController < ApplicationController

  def index
    @questions = Question.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @question = Question.find(params[:id])
    @answer = current_user.answers.build(:question => @question)
    session[:current_question_id] = @question.id
  end
  
  def new
    @question = Question.new()
    respond_to do |format|
      format.html { render_restfully_form }
      format.json { render :json => @question }
      format.xml  { render :xml => @question }
    end
  end
  
  def create
    @question = Question.new(params[:question])
    @question.author = current_user
    respond_to do |format|
      if @question.save
        current_user.notify_team(:new_question, @question)
        format.html { redirect_to (params[:redirect] || @question), :notice => "Les autres utilisateurs ont été notifié par mail" }
        format.json { render json => @question, :status => :created, :location => @question }
      else
        format.html { render_restfully_form }
        format.json { render :json => @question.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @question = Question.find(params[:id])
    respond_to do |format|
      format.html { render_restfully_form }
    end
  end
  
  def update
    @question = Question.find(params[:id])
    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to (params[:redirect] || @question) }
        format.json { head :no_content }
      else
        format.html { render_restfully_form }
        format.json { render :json => @question.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    respond_to do |format|
      format.html { redirect_to (params[:redirect] || questions_url) }
      format.json { head :no_content }
    end
  end

end
