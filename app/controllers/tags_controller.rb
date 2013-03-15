
class TagsController < BackendController

  def create
    done = false
    if params[:label] and params[:tagged] and request.xhr?
      tagged = params[:tagged].split(/\-+/)[0..1]
      @tagged = tagged[0].classify.constantize.find(tagged[1])
      label = Label.where("LOWER(name) LIKE ?", params[:label].mb_chars.downcase).first
      label ||= Label.create(:name => params[:label])
      Tag.create(:label => label, :tagged => @tagged)
      render :inline => '<%=tags_of(@tagged)-%>'
      done = true
    end
    return if done
    render :inline => ''
  end

  def destroy
    tag = Tag.find(params[:id])
    tag.destroy
    if request.xhr?
      head :ok # render :inline => '<%=tags_of(@tagged)-%>'
    else
      redirect_to labels_url
    end
  end

end
