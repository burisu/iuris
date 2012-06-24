class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
  validates_presence_of :first_name, :last_name, :email
  default_scope order(:last_name, :first_name)

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :post, :address, :phone, :public_email, :skills
  # attr_accessible :title, :body
  has_many :answers, :foreign_key => :author_id
  has_many :questions, :foreign_key => :author_id
  has_many :comments, :foreign_key => :author_id
  has_many :publications, :foreign_key => :author_id

  before_validation do
    self.administrator = true if User.count.zero?
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

end
