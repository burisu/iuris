# -*- coding: utf-8 -*-
class AnswersController < ApplicationController

  def index
    @answers = Answer.paginate(:page => params[:page], :per_page => 25)
  end

  def show
    answer = Answer.find(params[:id])
    redirect_to question_url(answer.question)
  end
  
  def new
    return unless question = Question.find(params[:question_id])
    @answer = question.answers.new()
    respond_to do |format|
      format.html { render_restfully_form }
      format.json { render :json => @answer }
      format.xml  { render :xml => @answer }
    end
  end
  
  def create
    return unless question = Question.find(params[:question_id])
    @answer = question.answers.new(params[:answer])
    @answer.author = current_user
    respond_to do |format|
      if @answer.save
        current_user.notify_team(:new_answer, @answer)
        format.html { redirect_to (params[:redirect] || question_url(@answer.question)), :notice => "Les autres utilisateurs ont été notifié par mail"}
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
