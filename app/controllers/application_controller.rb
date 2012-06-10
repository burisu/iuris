class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!


  def render_restfully_form(options={})
    operation = action_name.to_sym
    operation = (operation==:create ? :new : operation==:update ? :edit : operation)
    partial   = options[:partial]||'form'
    render(:template=>options[:template]||"forms/#{operation}", :locals=>{:operation=>operation, :partial=>partial, :options=>options})
  end

end
