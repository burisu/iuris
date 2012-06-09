class Answer < Message
  has_many :comments, :as => :origin

end
