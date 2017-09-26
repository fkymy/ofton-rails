class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :rememberable, :trackable, :authentication_keys => [:username]

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # devise without email
  # https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-sign-in-with-something-other-than-their-email-address
  # def email_required?
  #   false
  # end
  #
  # def email_changed?
  #   false
  # end

  # instead remove validatable module, and set customs:
  validates_presence_of :password, :on =>:create
  validates_confirmation_of :password, :on => :create
  validates_length_of :password, :within => Devise.password_length

  validates :username,
            presence: true,
            uniqueness: true,
            length: { maximum: 191 },
            on: :create

end

# == Schema Information
#
# Table name: users
#
# id             :integer          not null, primary key