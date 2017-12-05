class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :calculation_names
  validates_presence_of :email, :encrypted_password
end
