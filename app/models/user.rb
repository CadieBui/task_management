class User < ApplicationRecord
  before_destroy :last_admin!

  has_secure_password
  has_secure_password :recovery_password, validations: false

  has_many :tasks, dependent: :destroy

  validates :username, :presence => true, uniqueness: true
  validates :password, :presence => true

  def last_admin!
    if admin? && User.where(admin: true).count == 1
      errors.add(:base, I18n.t('forms.last_admin'))
      throw(:abort)
    end
  end
end
