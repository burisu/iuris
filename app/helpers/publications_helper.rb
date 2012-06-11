module PublicationsHelper

  def publication_name_form(nature)
    html = nature.title_format.dup
    for x in PublicationNature.name_columns
      html.gsub!(/\[#{x.to_s.upcase}\]/, (x == :date ? date_field(:publication, "name_#{x}") : text_field(:publication, "name_#{x}", :size => (x == :reference ? 10 : 20))))
    end
    return html.html_safe
  end

end
