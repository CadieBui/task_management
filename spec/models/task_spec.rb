require 'rails_helper'

RSpec.describe Task, type: :model do
  it "the title and content can not be null" do 
    task = FactoryBot.create(:task)
    expect(task.title).not_to eq("")
  end
end
