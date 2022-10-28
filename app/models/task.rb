class Task < ApplicationRecord
  belongs_to :user, optional: true
  
  validates :title, :presence => true,:length => { :minimum => 5 }, uniqueness: true
  validates :content,  :presence => true,:length => { :minimum => 5 }

  enum status: {not_set: 0, pending: 1, inprogress: 2, completed: 3 }
  enum priority: {not_set_priority: 0,high: 1, medium: 2, low: 3 }

  ransacker :status, formatter: ->(key) { statuses[key] } do |parent|
    parent.table[:status]
  end
  
  ransacker :priority, formatter: ->(key) { priorities[key] } do |parent|
    parent.table[:priority]
  end

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
