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

    context 'when input all empty' do
      it do
        visit signup_path
        run_signup('', '')
        run_expect_error('signup')
      end
    end

    context 'when username is empty' do
      it do
        visit signup_path
        run_signup('', user[:password])
        run_expect_error('signup')
      end
    end

    context 'when password is empty' do
      it do
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

    context 'when input all empty' do
      it do
        visit login_path
        run_login('', '')
        run_expect_error('login')
      end
    end

    context 'when username is empty' do
      it do
        visit login_path
        run_login('', user[:password])
        run_expect_error('login')
      end
    end

    context 'when username is wrong' do
      it do
        visit login_path
        run_login('username', user[:password])
        run_expect_error('login')
      end
    end

    context 'when password is empty' do
      it do
        visit login_path
        run_login(user[:username], '')
        run_expect_error('login')
      end
    end
    
    context 'when password is wrong' do
      it do
        visit login_path
        run_login(user[:username], '1111')
        run_expect_error('login')
      end
    end
  end

  describe 'admin flow' do
    let!(:user) { create(:user, password: password) }
    let!(:user1) { create(:user, username: "AAAA",  password: password) }
    let!(:user2) { { username: "Username" ,password: password}}

    context 'show users table' do
      it do
        visit login_path
        run_login(user.username, user.password)
        user.update(:admin => true)
        visit admin_users_path
        expect(page).to have_content("使用者管理")
      end
    end

    context 'show user table' do
      it do
        visit login_path
        run_login(user.username, user.password)
        user.update(:admin => true)
        visit admin_users_path
        visit admin_user_path(user1.id)
        expect(page).to have_content("詳細內容")
      end
    end

    context 'edit user' do
      it do
        visit login_path
        run_login(user.username, user.password)
        user.update(:admin => true)
        visit admin_users_path
        visit edit_admin_user_path(user1.id)
        fill_in I18n.t('forms.field_label.username'), with: user1.username
        fill_in I18n.t('forms.field_label.password'), with: "1111"
        click_button I18n.t('forms.button.edit_user')
        expect(page).to have_content("更新成功")
      end
    end

    context 'delete user' do
      it do
        visit login_path
        run_login(user.username, user.password)
        user.update(:admin => true)
        visit admin_users_path
        visit admin_user_path(user1.id)
        click_button I18n.t('forms.button.destroy_user')
        expect(page).to have_content("刪除成功")
      end
    end

    context 'create user' do
      it do
        visit login_path
        run_login(user.username, user.password)
        user.update(:admin => true)
        visit new_admin_user_path
        fill_in I18n.t('forms.field_label.username'), with: user2[:username]
        fill_in I18n.t('forms.field_label.password'), with: user2[:password]
        click_button I18n.t('forms.button.new')
        expect(page).to have_content("使用者新增成功！")
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
