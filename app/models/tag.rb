class Tag < ApplicationRecord
  has_many :tasks, through: :task_tags
  has_many :task_tags, dependent: :destroy

  validates :tagname, :presence => true, uniqueness: true
end