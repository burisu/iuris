# -*- coding: utf-8 -*-
module ApplicationHelper
  
  def menu_tag
    # separator = ' &nbsp; '.html_safe
    html = '<div id="menu">'.html_safe
    html_options = {}
    html_options[:class] = 'current' if controller_name.to_s == "home"
    html << link_to("&#9728;".html_safe, root_url, html_options)
    for kontroller in ["questions", "publications", "tools", "users!", "publication_natures!", "parameters!"] # "labels!", 
      if kontroller[-1..-1] != "!" or (kontroller[-1..-1] == "!" and current_user.administrator?)
        kontroller = kontroller.gsub(/\!*$/, '')
        html_options = {}
        html_options[:class] = 'current' if controller_name.to_s == kontroller
        html << link_to(action_title(:controller => kontroller), {:controller => kontroller, :action => :index}, html_options)
      end
    end
    html << '</div>'.html_safe
    return html
  end

  def page_title
    tr = "actions.#{controller_name}.#{action_name}"
    if tr.t.match(/^translation missing\:/) and Rails.env.production?
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
      html << "<div class=\"comments\">"
      # html << content_tag(:h3, "labels.x_comments".t(:count=>count))
      judged.comments.reorder('created_at ASC').each_with_index do |comment, index|
        html << "<div class='spacer'></div>" if index > 0
        html << "<div class='comment'>"
        html << content_tag(:span, comment.content, :class => :content)
        html << "<span class=\"meta\">"
        html << " &ndash; "
        html << link_to(comment.author.full_name, comment.author, :class => :author)
        html << " il y a "
        html << content_tag(:span, distance_of_time_in_words_to_now(comment.created_at), :class => :date)
        html << "</span>"
        html << "</div>"

      end
      html << "</div>"
    end
    return html.html_safe
  end

  def judged_description(judged)
    class_name = judged.class.name.underscore
    render :partial => "#{class_name.pluralize}/#{class_name}", :object => judged
  end

  def beautify(original_text)
    text = h(original_text.to_s)
    text.gsub!(/\s+\,\s*/, ', ')
    text.gsub!(/\s*\:/, '&nbsp;:')
    text.gsub!(/\s*\?/, '&nbsp;?')
    text.gsub!('&gt;&gt;', '&nbsp;&raquo;')
    text.gsub!('&lt;&lt;', '&laquo;&nbsp;')
    text.gsub!(/\~/, '&nbsp;')
    text.gsub!(/(\&nbsp\;)+/, '&nbsp;')
    text.gsub!(/\n/, '<br/>')
    # text.gsub!(/(\d+)(ième|ier|ière|ème|er|ère|nde|nd)/, '\1<sup>\2</sup>')
    return text.html_safe
  end

  def logo_tag(image_url, options = {})
    default_options = {:class => "logo"}
    options = default_options.merge(options)
    style = "background-image: url('#{h(image_url)}')"
    if options[:style]
      options[:style] << "; "+style
    else
      options[:style] = style
    end
    return content_tag(:div, nil, options)
  end
    
  def avatar_url(user, options = {})
    hash = Digest::MD5.hexdigest(user.email.strip.downcase)
    configuration = {:size => 96, :default => :retro, :force => false}
    configuration.update(options)
    return "https://secure.gravatar.com/avatar/#{hash}?s=#{configuration[:size]}&d=#{h(configuration[:default])}".html_safe # &f=#{options[:force] ? 'y' : 'n'}
  end

end
