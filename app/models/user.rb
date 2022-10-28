class User < ApplicationRecord
  has_secure_password
  has_secure_password :recovery_password, validations: false

  attr_accessor :password_digest, :recovery_password_digest
  has_many :task

  validates :username, :presence => true, uniqueness: true
  validates :password_digest,  :presence => true

end
