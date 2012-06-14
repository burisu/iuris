# -*- coding: utf-8 -*-
module ApplicationHelper
  
  def menu_tag
    # separator = ' &nbsp; '.html_safe
    html = '<div id="menu">'.html_safe
    html << link_to("Questions/Réponses", questions_url)
    html << link_to("Base de données", publications_url)
    html << link_to("Boîte à outils", tools_url)
    html << link_to("Mot-clés", labels_url)
    # html << link_to("Utilisateurs", users_url)
    html << link_to("Types de publication", publication_natures_url)
    # html << link_to("Paramètres", parameters_url)
    html << '</div>'.html_safe
    return html
  end

end
