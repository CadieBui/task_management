class Task < ApplicationRecord
  # enum :task_status, [:not_set ,:pending, :inprogress, :completed]
  include TranslateEnum

  validates :title, :presence => true,:length => { :minimum => 5 }, uniqueness: true
  validates :content,  :presence => true,:length => { :minimum => 5 }

  enum task_status: {not_set:0, pending: 1, inprogress: 2, completed: 3 }
  translate_enum :task_status


  def self.i18n_stages
    task_statuses.map do |status, idx|
      [I18n.t(status, scope:'forms.enum.status_enum'), idx]
    end
  end

  def status_i18n
    I18n.t("forms.enum.status_enum.#{task_status}")
  end
end
