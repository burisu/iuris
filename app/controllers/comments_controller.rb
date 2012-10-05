# -*- coding: utf-8 -*-
class CommentsController < ApplicationController

  def index
    @comments = Comment.paginate(:page => params[:page], :per_page => 25)
  end

  def show
    @comment = Comment.find(params[:id])
    session[:current_comment_id] = @comment.id
  end
  
  def new
    return unless judged = find(:judged)
    @comment = judged.comments.new()
    respond_to do |format|
      format.html { render_restfully_form }
      format.json { render :json => @comment }
      format.xml  { render :xml => @comment }
    end
  end
  
  def create
    return unless judged = find(:judged)
    @comment = judged.comments.new(params[:comment])
    @comment.author = current_user
    respond_to do |format|
      if @comment.save
        current_user.notify_team(:new_comment, @comment)
        format.html { redirect_to (params[:redirect] || judged_url(@comment.judged)), :notice => "Les autres utilisateurs ont été notifié par mail" }
        format.json { render json => @comment, :status => :created, :location => @comment }
      else
        format.html { render_restfully_form }
        format.json { render :json => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.html { render_restfully_form }
    end
  end
  
  def update
    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to (params[:redirect] || judged_url(@comment.judged)) }
        format.json { head :no_content }
      else
        format.html { render_restfully_form }
        format.json { render :json => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to (params[:redirect] || judged_url(@comment.judged)) }
      format.json { head :no_content }
    end
  end

  protected

  def find(mode=:comment)
    judged = nil
    for class_name in Comment.judgeds
      if jid = params["#{class_name}_id"]
        judged = class_name.to_s.classify.constantize.find(jid)
      end
    end
    unless judged
      # notify(:unfound_judged, :error)
      redirect_to root_url
      return nil
    end
    return judged if mode == :public
    # unless @current_user # and @current_user.can_manage?(judged)
    #   # notify(:access_denied, :error)
    #   redirect_to group_url(@current_group)
    #   return nil
    # end
    return judged if mode == :judged
    unless comment = Comment.find_by_id_and_origin_id_and_origin_type(params[:id], judged.id, judged.class.name)
      # notify(:unfound_comment, :error)
      redirect_to root_url
      return nil
    end
    return comment
  end


end
