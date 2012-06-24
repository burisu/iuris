# encoding: utf-8
module Iuris  #:nodoc:
  module Commentable
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def acts_as_commentable(options = {})
        code  = "has_many :comments, :as=>:origin, :include => :author, :order => 'updated_at DESC'\n"
        code << "def self.commentable?\n"
        code << "  true\n"
        code << "end\n"
        class_eval code
      end

    end
  end

  module CommentableUrlHelpers

    def judged_url(judged, options={})
      return root_url unless judged
      send("#{judged.class.name.underscore}_url", judged, options)
    end

    def judged_comments_url(judged, options={})
      return root_url unless judged
      send("#{judged.class.name.underscore}_comments_url", judged, options)
    end

    def new_judged_comment_url(judged, options={})
      return root_url unless judged
      send("new_#{judged.class.name.underscore}_comment_url", judged, options)
    end

  end
end

ActiveRecord::Base.send(:include, Iuris::Commentable)
ActionController::Base.send(:include, Iuris::CommentableUrlHelpers)
ActionView::Base.send(:include, Iuris::CommentableUrlHelpers)
