# encoding: utf-8
module Iuris  #:nodoc:
  module Searchable
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def acts_as_searchable(options = {})
        columns = options[:columns] || self.content_columns.collect{|c| c.name}
        code  = ""
        code << "def self.search(key)\n"
        code << "  words = key.mb_chars.downcase.gsub(/[^a-z0-9\ ]+/, '%').split(/\s+/).collect{|w| '%'+w+'%'}\n"
        code << "  conditions = ['1 = 1']\n"
        code << "  for word in words\n"
        code << "    conditions[0] << 'AND ("+columns.collect{|c| "LOWER(TRIM(CAST(#{c} AS VARCHAR))) LIKE ?"}.join(' OR ')+")'\n"
        code << "    conditions += [#{(['word'] * columns.size).join(', ')}]\n"
        code << "  end\n"
        code << "  self"
        code << ".where(conditions)\n"
        code << "end\n"
        class_eval code
      end

    end
  end
end

ActiveRecord::Base.send(:include, Iuris::Searchable)
