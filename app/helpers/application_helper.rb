# -*- coding: utf-8 -*-
module ApplicationHelper
  
  def menu_tag
    # separator = ' &nbsp; '.html_safe
    html = '<div id="menu">'.html_safe
    html << link_to(action_title(:controller => :questions), questions_url)
    html << link_to(action_title(:controller => :publications), publications_url)
    html << link_to(action_title(:controller => :tools), tools_url)
    html << link_to("Mot-clés", labels_url)
    html << link_to("Utilisateurs", users_url)
    html << link_to("Types de publication", publication_natures_url)
    html << link_to("Paramètres", parameters_url)
    html << '</div>'.html_safe
    return html
  end

  def page_title
    tr = "actions.#{controller_name}.#{action_name}"
    if tr.t.match(/^translation missing\:/)
      return ''
    else
      return content_tag(:h2, tr.t, :class=>"page-title")
    end
  end

  def action_title(options = {})
    aktion = options.delete(:action) || :index 
    kontroller = options.delete(:controller) || controller_name
    return "actions.#{kontroller}.#{aktion}".t(options)
  end


  def comments_of(judged)
    html = ""
    count = judged.comments.count
    if count > 0
      html << content_tag(:h3, "labels.x_comments".t(:count=>count))
      for comment in judged.comments.reorder('created_at ASC')
        html << "<div>"
        html << content_tag(:span, comment.content, :class => :comment)
        html << "<span class=\"comment-meta\">"
        html << " &mdash; "
        html << link_to(comment.author.full_name, comment.author, :class => :author)
        html << " il y a "
        html << content_tag(:span, distance_of_time_in_words_to_now(comment.created_at), :class => :date)
        html << "</span>"
        html << "</div>"
      end
    end
    return html.html_safe
  end

  def judged_description(judged)
    class_name = judged.class.name.underscore
    render :partial => "#{class_name.pluralize}/#{class_name}", :object => judged
  end

end
