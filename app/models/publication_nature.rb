class PublicationNature < ActiveRecord::Base
  attr_accessible :name, :title_format, :logo
  has_attached_file :logo, :styles => { :medium => "96x96#", :thumb => "48x48#" }
  has_many :publications, :dependent => :restrict 
  default_scope order(:name)
  serialize :title_fields, Hash

  Field = Struct.new(:id, :name, :pattern, :type, :required, :options)

  before_validation do
    if self.publications_count > 0
      old = self.class.find(self.id)
     # self.title_format = old.title_format
    end
    # Find and extract fields
    hash = {}
    id = "a"
    self.title_pattern = self.title_format.gsub(/\[[^\[\]]+\]/) do |k|
      parameters = k.to_s[1..-2].split("|")
      field = Field.new(id.dup)
      if md = parameters[0].match(/\<.+\>/)
        name = md.to_s
        field.name = name[1..-2].strip
        field.pattern = parameters[0].gsub(name, "%s")
      else
        field.name = parameters[0]  
        field.pattern = "%s"
      end
      parameters[1] ||= "!string"
      if parameters[1].to_s.match(/^\!/)
        parameters[1] = parameters[1][1..-1]
        field.required = true
      else
        field.required = false
      end
      field.type = parameters[1].to_sym
      field.type = :string unless [:string, :date].include?(field.type)
      field.options = {}
      for spair in parameters[2].to_s.split(/\s*\;\s*/)
        pair = spair.split(/\s*\:\s*/)
        field.options[pair[0].to_sym] = pair[1]
      end
      hash[id] = field
      id.succ!
      "%#{field.id}"
    end
    self.title_fields = hash
  end

  def format_title(values)
    title = self.title_pattern
    for key, field in self.title_fields
      value = values[field.id]
      if field.type == :date and field.options[:format] and !value.blank?
        value = value.to_date.l(:format => field.options[:format])
      else
        value = value.to_s
      end
      text = if value.blank?
               ''
             else
               field.pattern.gsub("%s", value)
             end
      
      title.gsub!("%"+field.id, text)
    end
    return title
  end

end
