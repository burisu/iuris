# -*- coding: utf-8 -*-
module ApplicationHelper
  
  def menu_tag
    # separator = ' &nbsp; '.html_safe
    html = '<div id="menu" class="navbar navbar-fixed-top"><div class="navbar-inner"><div class="container">'.html_safe
    
    html << '<a class="btn btn-navbar" data-toggle="collapse" data-target=".subnav-collapse"><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></a>'.html_safe

    html << ('<a class="brand" href="'+h(root_url)+'">'+h(Parameter["site.name"])+'</a>').html_safe
    html_options = {}
    html_options[:class] = 'current' if controller_name.to_s == "home"




    # html << link_to("&#9728;".html_safe, root_url, html_options)
    html << '<div class="nav-collapse subnav-collapse collapse">'.html_safe

    #search

    html << '<ul class="nav">'.html_safe
    for kontroller in ["questions", "publications", "tools"] # 
      html << ("<li" + (controller_name.to_s == kontroller ? " class=\"active\"" : "")+ ">").html_safe
      html << link_to(action_title(:controller => kontroller), {:controller => kontroller, :action => :index})
      html << '</li>'.html_safe
    end
    if current_user
      ak = ["users", "publication_natures", "labels", "parameters"]
      html << "<li class=\"dropdown#{ak.include?(controller_name.to_s) ? ' active' : ''}\">".html_safe
      html << "<a href=\"#\" class=\"dropdown-toggle\" data-toggle=\"dropdown\">".html_safe
      html << "<i class=\"icon-plus\"></i>".html_safe
      html << "<b class=\"caret\"></b></a>".html_safe
      html << "<ul class=\"dropdown-menu\">".html_safe
      html << content_tag(:li, link_to(current_user.full_name, user_url(current_user)))
      html << content_tag(:li, link_to("Se déconnecter", destroy_user_session_url, :method => :delete))
      if current_user.administrator?
        html << '<li class="divider"></li>'.html_safe          
        for kontroller in ak
          html << ("<li" + (controller_name.to_s == kontroller ? " class=\"active\"" : "")+ ">").html_safe
          html << link_to(action_title(:controller => kontroller), {:controller => kontroller, :action => :index})
          html << '</li>'.html_safe    
        end
      end
      html << "</ul>".html_safe
      html << "</li>".html_safe
    else
      html << content_tag(:li, link_to("Se connecter", new_user_session_url))
    end
    html << '</ul>'.html_safe

    html << "<form class=\"navbar-search pull-right\" action=\"#{search_url}\">".html_safe
    html << text_field_tag("q", params[:q], :placeholder => "Rechercher...", :class => "search-query span2")
    html << '</form>'.html_safe
    html << '</div>'.html_safe

    html << '</div></div></div>'.html_safe
    return html
  end

  NTR = {:notice => "Information", :warning => "Attention !", :success => "Bien joué !", :alert => "Oupps..."}

  def notification(mode)
    if flash[mode]
      bs_name = {:notice => :info, :warning => "", :alert => :error}[mode] || mode
      html = "".html_safe
      html << content_tag(:button, "&times;".html_safe, :type => "button", :class => "close", "data-dismiss" => "alert")
      html << content_tag(:h4, (NTR[mode]||mode).to_s.mb_chars.capitalize)
      html << flash[mode]
      return content_tag(:div, html, :class => "alert alert-block alert-#{bs_name}")
    end
    return ""
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


  def comments_of(judged, options = {}, &block)
    html = ""
    count = judged.comments.count
    if count > 0 or block_given? or options[:new_path]
      html << "<div class=\"comments\">"
      # html << content_tag(:h3, "labels.x_comments".t(:count=>count))
      judged.comments.reorder('created_at ASC').each_with_index do |comment, index|
        html << "<div class='spacer'></div>" if index > 0
        html << render(:partial => "comments/comment", :object => comment)
        # html << "<div class='comment'>"
        # html << logo_tag(avatar_url(comment.author, :size => 32), :title => comment.author.full_name)
        # html << "<div class='ms'>"
        # html << content_tag(:span, beautify(comment.content), :class => :content)
        # html << "<span class=\"info\">"
        # # html << " &ndash; "
        # html << link_to(comment.author.full_name, comment.author, :class => :author)
        # html << " "
        # html << on(comment.created_at)
        # html << "</span>"
        # html << "</div>"
        # html << "</div>"

      end
      if block_given?
        html << capture(&block)
      end
    if options[:new_path]
      html << content_tag(:div, :class => 'comment') do
        logo_tag(avatar_url(current_user, :size => 30), :title => current_user.full_name, :style => 'margin-top: 10px; width: 30px; height: 30px') +
          content_tag(:div, :class => 'ms') do
          toolbar do
            tool(options[:new_label] || 'Commenter ou compléter', options[:new_path], :icon => :comment, :text => true)
          end
        end
      end
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
    options[:class] ||= ""
    options[:class] << " logo"
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
      form =  text_field_tag("label", nil, :id => field_id, "data-autocomplete-with" => unroll_labels_url)
      form << button_tag(content_tag(:i, "", :class => "icon-tag"), "data-add-tag-label" => field_id, "data-add-tag-url"=>url_for(:controller => :tags, :action => :create, :tagged => tagged_id), "data-add-tag-to" => tags_id, :class => "btn")
      html << content_tag(:span, form, :class => "input-append")
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
      html << content_tag(:span, link_to(tag.label.name, tag.label), :class => :tag, :id => "tag-#{tag.id}")
    end
    html << "</span>"
    html << "</div>"
    return html.html_safe
  end


  def tags_of(tagged)
    html = ""
    for tag in tagged.tags
      tag_id = "tag-#{tag.id}"
      tag_html = link_to(tag.label.name, tag.label)
      if current_user  == tagged.author
        tag_html << h(" ") + link_to(content_tag(:i, '', :class => 'icon-remove'), tag, "data-remove-tag" => tag_id, :title => "Enlever")
      end
      html << content_tag(:span, tag_html, :class => :tag, :id => tag_id)
    end
    return html.html_safe
  end


  def toolbar(options = {}, &block)
    options[:class] ||= ""
    options[:class] << " btn-toolbar"
    return content_tag(:div, content_tag(:div, capture(&block), :class => "btn-group"), options)
  end

  INTERPOLATE = {
    "destroy" => "trash",
    "delete" => "trash",
    "edit" => "pencil",
    "new" => "plus"
  }

  def tool(*args)
    args[2] ||= {}
    args[2][:class] ||= ""
    args[2][:class] << " btn"
    if args[2][:icon]
      icon = args[2].delete(:icon).to_s
      icon.gsub!(/\_/, '-')
      icon = INTERPOLATE[icon] || icon
      text = args[0]
      args[2][:title] = text
      args[0] = content_tag(:i, nil, :class => "icon-"+icon) #  + h(args[0])
      args[0] << h(' ' + text) if args[2][:text]
    end
    link_to(*args)
  end
  

  def on(made_at)
    return h('il y a ') + content_tag(:span, distance_of_time_in_words_to_now(made_at), :title => made_at.l(format: :long))
    today = Date.today
    made_on = made_at.to_date
    date = if made_on == today
             # Aujourd'hui (à ??:??)
             "aujourd'hui"
           elsif made_on == today - 1
             # Hier (à ??:??)
             "hier"
           elsif made_on == today - 2
             # Avant-hier (à ??:??)
             "avant-hier"
           elsif made_on - today < 1.year
             # le ?? ???? (à ??:??)
             "le " + made_on.to_date.l(:format => :short)
           else
             # le ?? ???? ???? (à ??:??)
             "le " + made_on.to_date.l(:format => :long)
           end
    if made_at.is_a?(Time) or made_at.is_a?(DateTime)
      date += " à #{made_at.hour}:#{made_at.min.to_s.rjust(2, '0')}" #  #{made_at.zone}
    end
    return content_tag(:span, date, :title => made_at.iso8601, :class => :date)
  end

end
