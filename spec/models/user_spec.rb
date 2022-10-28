require 'rails_helper'

RSpec.describe User, type: :model do
  # Shoulda
  describe 'Validations' do
    it { should validate_presence_of(:username) }
    it { should validate_length_of(:username) }

    it { should validate_presence_of(:password_digest) }
    it { should validate_length_of(:password_digest) }
  end
end
