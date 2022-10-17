class Task < ApplicationRecord
  validates :title, :presence => true,:length => { :minimum => 5 }, uniqueness: true
  validates :content,  :presence => true,:length => { :minimum => 5 }
end
