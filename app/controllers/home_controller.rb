class HomeController < ApplicationController

  def index
  end

  def search
    @results = {}
    params[:q]
    for klass in [Question, Answer, Publication, Comment]
      @results[klass] = klass.search(params[:q])
    end
  end

end
