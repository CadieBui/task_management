class Task < ApplicationRecord
  include TranslateEnum

  validates :title, :presence => true,:length => { :minimum => 5 }, uniqueness: true
  validates :content,  :presence => true,:length => { :minimum => 5 }

  enum status: {not_set: 0, pending: 1, inprogress: 2, completed: 3 }
  translate_enum :status
  enum priority: {high: 0, medium: 1, low: 2 }
  translate_enum :priority

  def self.i18n_stages
    statuses.keys.map  do |status|
      [I18n.t(status, scope:'forms.enum.status_enum'), status]
    end
  end

  def self.i18n_prior
    priorities.keys.map  do |priority|
      [I18n.t(priority, scope:'forms.enum.priority_enum'), priority]
    end
  end

end
