require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:password) { '1234' }

  before do
    driven_by(:rack_test)
  end

  describe 'sign up flow' do
    let!(:user) { { username: "Username" ,password: password}}

    it 'success' do
      run_signup(user[:username], user[:password])
      expect(page).to have_content(I18n.t("forms.create.signup_success"))
      expect(page).to have_current_path("/")
      expect(user[:username]).to be_present
    end

    context 'when' do
      it 'input all empty' do
        visit signup_path
        run_signup('', '')
        run_expect_error('signup')
      end

      it 'username is empty' do
        visit signup_path
        run_signup('', user[:password])
        run_expect_error('signup')
      end

      it 'password is empty' do
        visit signup_path
        run_signup(user[:username], '')
        run_expect_error('signup')
      end

    end
  end

  describe 'login' do
    let!(:user) { create(:user, password: password) }

    it 'success' do
      visit login_path
      run_login(user.username, user.password)
      run_expect_login_success(user[:username])
    end

    context 'when' do
      it 'input all empty' do
        visit login_path
        run_login('', '')
        run_expect_error('login')
      end

      it 'username is empty' do
        visit login_path
        run_login('', user[:password])
        run_expect_error('login')
      end

      it 'username is wrong' do
        visit login_path
        run_login('username', user[:password])
        run_expect_error('login')
      end

      it 'password is empty' do
        visit login_path
        run_login(user[:username], '')
        run_expect_error('login')
      end

      it 'password is wrong' do
        visit login_path
        run_login(user[:username], '1111')
        run_expect_error('login')
      end
    end
  end

  private

  def run_signup(username, password)
    visit signup_path
    fill_in I18n.t('forms.field_label.username'), with: username
    fill_in I18n.t('forms.field_label.password'), with: password
    click_button I18n.t('forms.button.signup')
  end

  def run_login(username, password)
    visit login_path
    fill_in I18n.t('forms.field_label.username'), with: username
    fill_in I18n.t('forms.field_label.password'), with: password
    click_button I18n.t('forms.button.login')
  end

  def run_expect_login_success(user)
    expect(page).to have_content(I18n.t("forms.create.login_success"))
    expect(page).to have_current_path("/")
    expect(user).to be_present
  end

  def run_expect_error(path)
    if path == 'login'
      expect(page).to have_content("帳號或密碼錯誤")
      expect(page).to have_current_path("/#{path}")
    else 
      expect(page).to have_content("error")
      expect(page).to have_current_path("/#{path}")
    end
  end

end
