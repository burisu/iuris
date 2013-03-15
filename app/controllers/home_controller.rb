class HomeController < BackendController

  def index
  end

  def search
    @results = {}
    params[:q]
    for klass in [Question, Answer, Publication, Comment, User]
      @results[klass] = klass.search(params[:q])
    end
  end

end
