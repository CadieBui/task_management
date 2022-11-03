require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:rack_test)
    Task.destroy_all
  end

  # success case in create
  scenario "valid title, content, endtime, status in create" do
    title = Faker::Lorem.sentence
    content = Faker::Lorem.sentence
    endtime = Time.now
    status = 'pending'
    priority = 'high'
    run_create_task(title: title, content: content, endtime: endtime, status: status, priority: priority)
    expect(page).to have_content I18n.t('forms.create.success')
    expect(Task.find_by(title: title, content: content)).to be_present
  end

  # success case in create
  scenario "valid title, content, endtime, status in create" do
    title = Faker::Lorem.sentence
    content = Faker::Lorem.sentence
    endtime = ""
    status = 'pending'
    priority = 'high'
    run_create_task(title: title, content: content, endtime: endtime, status: status, priority: priority)
    expect(page).to have_content I18n.t('forms.create.success')
    expect(Task.find_by(title: title, content: content)).to be_present
  end

  # success case in edit
  scenario "valid title, content, endtime, status in edit" do
    title = Faker::Lorem.sentence
    content = Faker::Lorem.sentence
    endtime = Time.now
    status = 'pending'
    priority = 'high'
    run_edit_task(title: title, content: content, endtime: endtime, status: status, priority: priority)
    expect(page).to have_content I18n.t('forms.edit.success')
    expect(Task.find_by(title: title, content: content)).to be_present
  end

  # success case in edit
  scenario "valid title, content, endtime, status in edit" do
    title = Faker::Lorem.sentence
    content = Faker::Lorem.sentence
    endtime = ""
    status = 'pending'
    priority = 'high'
    run_edit_task(title: title, content: content, endtime: endtime, status: status, priority: priority)
    expect(page).to have_content I18n.t('forms.edit.success')
    expect(Task.find_by(title: title, content: content)).to be_present
  end

  # success case in delete
  scenario "deleted successfully" do
    run_delete_task
    expect(page).to have_content I18n.t('forms.delete.success')
  end

  # error case in create
  scenario "empty title and content in create" do
    status = 'pending'
    priority = 'high'
    run_create_task(title: '', content: '', endtime: '', status: status, priority: priority)
    expect(page).to have_content("error")
  end

  # error case in create
  scenario "empty title in create " do
    content = Faker::Lorem.sentence
    status = 'pending'
    priority = 'high'
    run_create_task(title: '', content: content, endtime: Time.current, status: status, priority: priority)
    expect(page).to have_content('error')
  end

  # error case in create
  scenario "empty content in create " do
    title = Faker::Lorem.sentence
    status = 'pending'
    priority = 'high'
    run_create_task(title: title, content: '', endtime: Time.current, status: status, priority: priority)
    expect(page).to have_content("error")
  end

  # error case in edit
  scenario "empty title and content in edit" do
    status = 'pending'
    priority = 'high'
    run_edit_task(title: '', content: '', endtime: '', status: status, priority: priority)
    expect(page).to have_content("error")
  end

  # error case in edit
  scenario "empty title in edit " do
    content = Faker::Lorem.sentence
    status = 'pending'
    priority = 'high'
    run_edit_task(title: '', content: content, endtime: '', status: status, priority: priority)
    expect(page).to have_content("error")
  end

  # error case in edit
  scenario "empty content in edit " do
    title = Faker::Lorem.sentence
    status = 'pending'
    priority = 'high'
    run_edit_task(title: title, content: '', endtime: '', status: status, priority: priority)
    expect(page).to have_content("error")
  end

  # success case in show list sort by create time
  scenario "list sort by create time " do
    username = "TEST"
    password = "TEST"
    run_signup(username: username, password: password)
    run_login(username: username, password: password)
    visit tasks_path
    click_link I18n.t('sort.created_at')
    expect(page).to have_current_path("/tasks?q%5Bs%5D=created_at+desc")
  end

  # success case in search list by title and status and priority
  scenario "list search by title and status and priority" do
    visit new_task_path
    title = "This is a test"
    content = "This is a test content"
    endtime = ""
    status = 'pending'
    priority = 'high'
    run_create_task(title: title, content: content, endtime: endtime, status: status, priority: priority)
    visit tasks_path
    fill_in I18n.t('forms.search.title'), with: "This"
    find("#q_status_eq > option[value=#{status}]").select_option
    find("#q_priority_eq> option[value=#{priority}]").select_option
    find('input[name="Search"]').click
    expect(page).to have_content("#{title}")
    expect(page).to have_content(I18n.t("forms.enum.status_enum.#{status}"))
    expect(page).to have_content(I18n.t("forms.enum.priority_enum.#{priority}"))
    expect(page).to have_current_path("/tasks?q[title_cont]=This&q[status_eq]=pending&q[priority_eq]=high&Search=%E6%90%9C%E5%B0%8B")
  end

  # success case in search list by title and status
  scenario "list search by title and status " do
    visit new_task_path
    title = "This is a test"
    content = "This is a test content"
    endtime = ""
    status = 'pending'
    priority = 'not_set_priority'
    run_create_task(title: title, content: content, endtime: endtime, status: status, priority: priority)
    visit tasks_path
    fill_in I18n.t('forms.search.title'), with: "This"
    find("#q_status_eq > option[value=#{status}]").select_option
    find('input[name="Search"]').click
    expect(page).to have_content("#{title}")
    expect(page).to have_content(I18n.t("forms.enum.status_enum.#{status}"))
    expect(page).to have_current_path("/tasks?q[title_cont]=This&q[status_eq]=pending&q[priority_eq]=&Search=%E6%90%9C%E5%B0%8B")
  end

  # success case in search list by title
  scenario "list search by title" do
    visit new_task_path
    title = "This is a test"
    content = "This is a test content"
    endtime = ""
    status = 'not_set'
    priority = 'not_set_priority'
    run_create_task(title: title, content: content, endtime: endtime, status: status, priority: priority)
    visit tasks_path
    fill_in I18n.t('forms.search.title'), with: "This"
    find('input[name="Search"]').click
    expect(page).to have_content("#{title}")
    expect(page).to have_current_path("/tasks?q[title_cont]=This&q[status_eq]=&q[priority_eq]=&Search=%E6%90%9C%E5%B0%8B")
  end

  # success case in search list by status
  scenario "list search by status" do
    visit new_task_path
    title = "This is a test"
    content = "This is a test content"
    endtime = ""
    status = 'inprogress'
    priority = 'not_set_priority'
    run_create_task(title: title, content: content, endtime: endtime, status: status, priority: priority)
    visit tasks_path
    find("#q_status_eq > option[value=#{status}]").select_option
    find('input[name="Search"]').click
    expect(page).to have_content(I18n.t("forms.enum.status_enum.#{status}"))
    expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=inprogress&q[priority_eq]=&Search=%E6%90%9C%E5%B0%8B")
  end

  # success case in search list by status
  scenario "list search by priority" do
    visit new_task_path
    title = "This is a test"
    content = "This is a test content"
    endtime = ""
    status = 'not_set'
    priority = 'high'
    run_create_task(title: title, content: content, endtime: endtime, status: status, priority: priority)
    visit tasks_path
    find("#q_priority_eq > option[value=#{priority}]").select_option
    find('input[name="Search"]').click
    expect(page).to have_content(I18n.t("forms.enum.priority_enum.#{priority}"))
    expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=&q[priority_eq]=high&Search=%E6%90%9C%E5%B0%8B")
  end

  # success case in search list by status
  scenario "list search by priority and status" do
    visit new_task_path
    title = "This is a test"
    content = "This is a test content"
    endtime = ""
    status = 'pending'
    priority = 'high'
    run_create_task(title: title, content: content, endtime: endtime, status: status, priority: priority)
    visit tasks_path
    find("#q_priority_eq > option[value=#{priority}]").select_option
    find("#q_status_eq > option[value=#{status}]").select_option
    find('input[name="Search"]').click
    expect(page).to have_content(I18n.t("forms.enum.priority_enum.#{priority}"))
    expect(page).to have_content(I18n.t("forms.enum.status_enum.#{status}"))
    expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=pending&q[priority_eq]=high&Search=%E6%90%9C%E5%B0%8B")
  end

  # success case in search list by status
  scenario "list search by priority and title" do
    visit new_task_path
    title = "This is a test"
    content = "This is a test content"
    endtime = ""
    status = 'not_set'
    priority = 'high'
    run_create_task(title: title, content: content, endtime: endtime, status: status, priority: priority)
    visit tasks_path
    find("#q_priority_eq > option[value=#{priority}]").select_option
    fill_in I18n.t('forms.search.title'), with: "This"
    find('input[name="Search"]').click
    expect(page).to have_content(I18n.t("forms.enum.priority_enum.#{priority}"))
    expect(page).to have_current_path("/tasks?q[title_cont]=This&q[status_eq]=&q[priority_eq]=high&Search=%E6%90%9C%E5%B0%8B")
  end

  private

  # test create task
  def run_create_task(title:, content:, endtime:, status:, priority:)
    username = "TEST"
    password = "TEST"
    run_signup(username: username, password: password)
    run_login(username: username, password: password)
    visit new_task_path
    fill_in I18n.t('forms.field_label.title'), with: title
    fill_in I18n.t('forms.field_label.content'), with: content
    fill_in I18n.t('forms.field_label.endtime'), with: endtime
    find("#task_status > option[value='#{status}']").select_option
    find("#task_priority > option[value='#{priority}']").select_option
    click_button I18n.t('forms.button.submit')
  end

  # test edit task
  def run_edit_task(title:, content:, endtime:, status:, priority:)
    user = create(:user)
    task = Task.create(title: Faker::Lorem.sentence, content: Faker::Lorem.sentence, user_id: user.id)
    run_login(username: user.username, password: "1111")
    visit edit_task_path(task)
    fill_in I18n.t('forms.field_label.title'), with: title
    fill_in I18n.t('forms.field_label.content'), with: content
    fill_in I18n.t('forms.field_label.endtime'), with: endtime
    find("#task_status > option[value='#{status}']").select_option
    find("#task_priority > option[value='#{priority}']").select_option
    click_button I18n.t('forms.button.submit')
  end

  # test delete task
  def run_delete_task
    user = create(:user)
    run_login(username: user.username, password: "1111")
    task = Task.create(title: Faker::Lorem.sentence, content: Faker::Lorem.sentence, user_id: user.id)
    visit task_path(task)
    click_button I18n.t('forms.button.destroy')
  end

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
