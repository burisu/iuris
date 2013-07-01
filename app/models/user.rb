# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  administrator          :boolean          default(FALSE), not null
#  post                   :string(255)
#  address                :string(255)
#  phone                  :string(255)
#  public_email           :string(255)
#  skills                 :text
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  authentication_token   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  lock_version           :integer          default(0), not null
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  acts_as_searchable
  devise :database_authenticatable, :trackable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
  validates_presence_of :first_name, :last_name, :email, :skills, :post, :phone
  default_scope order(:last_name, :first_name)

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :post, :address, :phone, :public_email, :skills
  # attr_accessible :title, :body
  has_many :answers, :foreign_key => :author_id
  has_many :questions, :foreign_key => :author_id
  has_many :comments, :foreign_key => :author_id
  has_many :publications, :foreign_key => :author_id

  before_validation do
    self.first_name = self.first_name.mb_chars.capitalize
    self.last_name = self.last_name.mb_chars.upcase
    self.administrator = true if User.count.zero?
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def email_sign
    "\"" + self.full_name.gsub('"', "''") + "\" <" + self.email + ">"
  end

  def notify_team(notification, *args)
    for user in User.where("id != ?", self.id).all
      Notifier.send(notification, user, *args).deliver
    end
  end

end
