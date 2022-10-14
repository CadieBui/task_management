require 'rails_helper'

RSpec.describe Task, type: :model do
  # Shoulda
  describe 'Validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title) }

    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content) }
  end
end
