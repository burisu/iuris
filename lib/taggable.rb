# encoding: utf-8
module Iuris  #:nodoc:
  module Taggable
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def acts_as_taggable(options = {})
        columns = options[:columns] || self.content_columns.collect{|c| c.name}
        code  = ""
        code << "has_many :tags, :as => :tagged, :include => :label\n"
        code << "has_many :labels, :through => :tags, :order => :name\n"
        if self.columns.detect{|c| c.name.to_s == "tags_list"}
          code << "before_validation do\n"
          code << "  self.tags_list = self.tags.collect{|t| t.label.name}.join(', ')\n"
          code << "end\n"
        end
        class_eval code
      end

    end
  end
end

ActiveRecord::Base.send(:include, Iuris::Taggable)
