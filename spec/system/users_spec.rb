require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end
  # success case in sign up
  scenario "sign up successfully" do  
    username = Faker::Name.unique.name
    password = Faker::Number.number(digits: 10)
    run_signup(username: username, password: password)
    expect(page).to have_content(I18n.t("forms.create.signup_success")) 
    expect(page).to have_current_path("/")
  end
  # success case in login
  scenario "login successfully" do  
    username = Faker::Name.unique.name
    password = Faker::Number.number(digits: 10)
    run_signup(username: username, password: password)
    expect(page).to have_content(I18n.t("forms.create.signup_success"))  
    run_login(username: username, password: password)
    expect(page).to have_content(I18n.t("forms.create.login_success"))  
    expect(page).to have_current_path("/")
  end

  # error case in login
  scenario "login with username and password empty" do  
    run_login(username: "", password: "")
    expect(page).to have_content("帳號或密碼錯誤")
    expect(page).to have_current_path("/login")
  end

  # error case in login
  scenario "login with username empty" do 
    username = ""
    password = Faker::Number.number(digits: 10)
    run_login(username: username, password: password)
    expect(page).to have_content("帳號或密碼錯誤")
    expect(page).to have_current_path("/login")
  end

  # error case in login
  scenario "login with password empty" do 
    username = Faker::Name.unique.name
    password = ""
    run_login(username: username, password: password)
    expect(page).to have_content("帳號或密碼錯誤")
    expect(page).to have_current_path("/login")
  end

  # error case in login
  scenario "login with wrong password" do 
    username1 = "TEST"
    password1 = "TEST"
    run_signup(username: username1, password: password1)
    username2 = "TEST"
    password2 = Faker::Number.number(digits: 10)
    run_login(username: username2, password: password2)
    expect(page).to have_content("帳號或密碼錯誤")
    expect(page).to have_current_path("/login")
  end

  # error case in login
  scenario "login with wrong username" do 
    username1 = "TEST"
    password1 = "TEST"
    run_signup(username: username1, password: password1)
    username2 = "TESTTEST"
    password2 = "TEST"
    run_login(username: username2, password: password2)
    expect(page).to have_content("帳號或密碼錯誤")
    expect(page).to have_current_path("/login")
  end

  private
    def run_signup(username:, password:)
      visit signup_path
      fill_in I18n.t('forms.field_label.username'), with: username
      fill_in I18n.t('forms.field_label.password'), with: password
      click_button I18n.t('forms.button.signup')
    end
    def run_login(username:, password:)
      visit login_path
      fill_in I18n.t('forms.field_label.username'), with: username
      fill_in I18n.t('forms.field_label.password'), with: password
      click_button I18n.t('forms.button.login')
    end
end
