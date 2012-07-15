class HomeController < ApplicationController

  def index
  end

  def search
    @results = {}
    params[:q]
    for klass in [Question, Publication]
      # @results[klass] = klass.search(params[:q])
    end
  end

end
