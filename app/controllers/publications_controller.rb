# -*- coding: utf-8 -*-
class PublicationsController < ApplicationController

  def index
    @publications = Publication.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @publication = Publication.find(params[:id])
    session[:current_publication_id] = @publication.id
    respond_to do |format|
      format.html { }
      format.pdf  { send_file @publication.document.path("original"), :type => @publication.document.content_type, :disposition => 'inline', :filename => @publication.name.parameterize+".pdf" }
    end
  end
  
  def new
    @publication = Publication.new
    if params[:nature_id]
      @publication.nature = PublicationNature.find_by_id(params[:nature_id])
    end
    respond_to do |format|
      format.html { request.xhr? ? render(:partial => "name_form") : render_restfully_form(:multipart => true) }
      format.json { render :json => @publication }
      format.xml  { render :xml => @publication }
    end
  end
  
  def create
    @publication = Publication.new(params[:publication])
    @publication.author = current_user
    respond_to do |format|
      if @publication.save
        current_user.notify_team(:new_publication, @publication)
        format.html { redirect_to (params[:redirect] || @publication), :notice => "Les autres utilisateurs ont été notifié par mail" }
        format.json { render json => @publication, :status => :created, :location => @publication }
      else
        format.html { render_restfully_form(:multipart => true) }
        format.json { render :json => @publication.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @publication = Publication.find(params[:id])
    respond_to do |format|
      format.html { render_restfully_form(:multipart => true) }
    end
  end
  
  def update
    @publication = Publication.find(params[:id])
    respond_to do |format|
      if @publication.update_attributes(params[:publication])
        format.html { redirect_to (params[:redirect] || @publication) }
        format.json { head :no_content }
      else
        format.html { render_restfully_form(:multipart => true) }
        format.json { render :json => @publication.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @publication = Publication.find(params[:id])
    @publication.destroy
    respond_to do |format|
      format.html { redirect_to (params[:redirect] || publications_url) }
      format.json { head :no_content }
    end
  end

end
