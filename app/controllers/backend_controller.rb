# -*- coding: utf-8 -*-
class BackendController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_fields!

  protected
  
  def check_fields!
    if current_user
      unless current_user.valid?
        redirect_to edit_user_url(current_user), :notice => "Vous devez mettre à jour votre fiche"
        return false
      end
    end
  end
end
