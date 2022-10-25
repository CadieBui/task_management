class Task < ApplicationRecord
  include TranslateEnum

  validates :title, :presence => true,:length => { :minimum => 5 }, uniqueness: true
  validates :content,  :presence => true,:length => { :minimum => 5 }

  enum status: {not_set: 0, pending: 1, inprogress: 2, completed: 3 }
  translate_enum :status

  def self.i18n_stages
    statuses.map do |status, idx|
      [I18n.t(status, scope:'forms.enum.status_enum'), status]
    end
  end

  def status_i18n
    I18n.t("forms.enum.status_enum.#{status}")
  end
end
