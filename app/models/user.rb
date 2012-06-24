class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
  validates_presence_of :first_name, :last_name, :email

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  # attr_accessible :title, :body
  has_many :answers, :foreign_key => :author_id
  has_many :questions, :foreign_key => :author_id
  has_many :comments, :foreign_key => :author_id
  has_many :publications, :foreign_key => :author_id

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

end
