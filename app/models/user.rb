class User < ApplicationRecord
  has_secure_password
  has_secure_password :recovery_password, validations: false

  has_many :tasks, dependent: :destroy

  validates :username, :presence => true, uniqueness: true
  validates :password, :presence => true
end
