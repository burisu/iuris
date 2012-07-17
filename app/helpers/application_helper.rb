# -*- coding: utf-8 -*-
module ApplicationHelper
  
  def menu_tag
    # separator = ' &nbsp; '.html_safe
    html = '<div id="menu">'.html_safe
    html_options = {}
    html_options[:class] = 'current' if controller_name.to_s == "home"
    html << link_to("&#9728;".html_safe, root_url, html_options)
    for kontroller in ["questions", "publications", "tools", "users!", "publication_natures!", "labels!", "parameters!"] # 
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
    if tr.t.match(/^translation missing\:/) # and Rails.env.production?
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

  def version
    value = nil
    File.open(Rails.root.join("VERSION"), "rb") do |f|
      value = f.read
    end
    return value
  end


  def comments_of(judged, &block)
    html = ""
    count = judged.comments.count
    if count > 0 or block_given?
      html << "<div class=\"comments\">"
      # html << content_tag(:h3, "labels.x_comments".t(:count=>count))
      judged.comments.reorder('created_at ASC').each_with_index do |comment, index|
        html << "<div class='spacer'></div>" if index > 0
        html << "<div class='comment'>"
        html << logo_tag(avatar_url(comment.author, :size => 32))
        html << content_tag(:span, beautify(comment.content), :class => :content)
        html << "<span class=\"info\">"
        # html << " &ndash; "
        html << link_to(comment.author.full_name, comment.author, :class => :author)
        html << " il y a "
        html << content_tag(:span, distance_of_time_in_words_to_now(comment.created_at), :class => :date)
        html << "</span>"
        html << "<div class=\"end\"></div>"
        html << "</div>"

      end
      if block_given?
        html << capture(&block)
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
    text = h(original_text.to_s.strip)

    if params[:q]
      keys = params[:q].mb_chars.downcase.split(/\s+/)
      for key in keys
        text = highlight(text, key)
      end
    end

    text.gsub!(/^\s*(\-|\*)\s+([^\n]+)(\n|$)/, '<ul><li>\2</li></ul>')
    text.gsub!(/\<\/ul\>\s*\<ul\>/, '')

    text.gsub!(/^\s*(\#)\s+([^\n]+)(\n|$)/, '<ol><li>\1</li></ol>')
    text.gsub!(/\<\/ol\>\s*\<ol\>/, '')

    text.gsub!(/\s+\,\s*/, ', ')
    text.gsub!(/\s*\:/, '&nbsp;:')
    text.gsub!(/[\s\u00A0]*\?/, '&nbsp;?')
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

  def labels_for(tagged)
    tagged_id = tagged.class.name.underscore+"-"+tagged.id.to_s
    tags_id = "tags-of-"+tagged_id
    html = ""
    html << "<div class=\"tagger\">"
    html << "<span class=\"tags\" id=\"#{tags_id}\">"
    html << tags_of(tagged)
    html << "</span>"
    if current_user == tagged.author
      field_id = tagged_id + "-label"
      html << text_field_tag("label", nil, :id => field_id, "data-autocomplete-with" => unroll_labels_url)
      html << button_tag("+", "data-add-tag-label" => field_id, "data-add-tag-url"=>url_for(:controller => :tags, :action => :create, :tagged => tagged_id), "data-add-tag-to" => tags_id)
    end
    html << "</div>"
    return html.html_safe
  end

  def labels_of(tagged)
    tagged_id = tagged.class.name.underscore+"-"+tagged.id.to_s
    tags_id = "tags-of-"+tagged_id
    html = ""
    html << "<div class=\"tagger\">"
    html << "<span class=\"tags\" id=\"#{tags_id}\">"
    for tag in tagged.tags
      html << link_to(tag.label.name, tag.label, :class => :tag, :id => "tag-#{tag.id}")
    end
    html << "</span>"
    html << "</div>"
    return html.html_safe
  end


  def tags_of(tagged)
    html = ""
    for tag in tagged.tags
      tag_id = "tag-#{tag.id}"
      html << link_to(tag.label.name, tag.label, :class => :tag, :id => tag_id)
      if current_user  == tagged.author
        html << link_to("Enlever", tag, :class => :remove, "data-remove-tag" => tag_id)
      end
    end
    return html.html_safe
  end



end
