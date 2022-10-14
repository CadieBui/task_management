require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'Validations' do
    # 驗證的目標可以是`沒有錯誤`或是`DB有資料`之類，只要能夠測試到正確性的都可以，這個沒有一定規則
    subject { task.errors.empty? }
    before { task.save }

    # 通常會用context來做條件區別
    context 'when input `title` and `content`' do
      let(:task) { build(:task) }

      it { is_expected.to be true }
    end
  
    context 'when only input `title`' do
      let(:task) { build(:task, content: '') }
      
      it { is_expected.to be false }
    end
  
    context 'when only input `content`' do
      let(:task) { build(:task, title: '') }

      it { is_expected.to be false }
    end
  
    context 'when no input' do
      let(:task) { build(:task, title: '', content: '') }
      
      it { is_expected.to be false }
    end
  end

  # Shoulda
  describe 'Validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title) }

    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content) }

  end
end
