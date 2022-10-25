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
    run_create_task(title: title, content: content, endtime: endtime, task_status: status)
    expect(page).to have_content I18n.t('forms.create.success')
    expect(Task.find_by(title: title, content: content)).to be_present
  end

  # success case in create
  scenario "valid title, content, endtime, status in create" do  
    title = Faker::Lorem.sentence
    content = Faker::Lorem.sentence
    endtime = ""
    status = 'pending'
    run_create_task(title: title, content: content, endtime: endtime, task_status: status)
    expect(page).to have_content I18n.t('forms.create.success')
    expect(Task.find_by(title: title, content: content)).to be_present
  end

  # success case in edit
  scenario "valid title, content, endtime, status in edit" do  
    title = Faker::Lorem.sentence
    content = Faker::Lorem.sentence
    endtime = Time.now
    status = 'pending'
    run_edit_task(title: title, content: content, endtime: endtime, task_status: status)
    expect(page).to have_content I18n.t('forms.edit.success')
    expect(Task.find_by(title: title, content: content)).to be_present
  end

  # success case in edit
  scenario "valid title, content, endtime, status in edit" do  
    title = Faker::Lorem.sentence
    content = Faker::Lorem.sentence
    endtime = ""
    status = 'pending'
    run_edit_task(title: title, content: content, endtime: endtime, task_status: status)
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
    run_edit_task(title:'', content: '', endtime: '', task_status: status)
    expect(page).to have_content("error")
  end

  # error case in create
  scenario "empty title in create " do       
    content = Faker::Lorem.sentence
    status = 'pending'
    run_create_task(title:'', content: content, endtime: Time.current, task_status: status)
    expect(page).to have_content('error')
  end

  # error case in create
  scenario "empty content in create " do  
    title = Faker::Lorem.sentence
    status = 'pending'
    run_create_task(title: title, content: '', endtime: Time.current, task_status: status)
    expect(page).to have_content("error")
  end

  # error case in edit
  scenario "empty title and content in edit" do  
    status = 'pending'
    run_edit_task(title:'', content: '', endtime: '', task_status: status)
    expect(page).to have_content("error")
  end

  # error case in edit
  scenario "empty title in edit " do       
    content = Faker::Lorem.sentence
    status = 'pending'
    run_edit_task(title:'', content: content, endtime: '', task_status: status)
    expect(page).to have_content("error")
  end

  # error case in edit
  scenario "empty content in edit " do  
    title = Faker::Lorem.sentence
    status = 'pending'
    run_edit_task(title: title, content: '', endtime: '', task_status: status)
    expect(page).to have_content("error")
  end 

  # success case in show list sort by create time
  scenario "list sort by create time " do  
    visit tasks_path
    click_link I18n.t('sort.created_at')
    expect(page).to have_current_path("/tasks?q%5Bs%5D=created_at+desc")  
  end 

  # success case in search list by title and status
  scenario "list search by title and status" do  
    visit new_task_path
    title = "This is a test"
    content = "This is a test content"
    endtime = ""
    status = 'pending'
    run_create_task(title: title, content: content, endtime: endtime, task_status: status)
    visit tasks_path
    fill_in I18n.t('forms.search.title'), with: "This"
    find("#q_task_status_eq > option[value='pending']").select_option
    find('input[name="Search"]').click
    expect(page).to have_content("#{title}")  
    expect(page).to have_current_path("/tasks?q[title_cont]=This&q[task_status_eq]=pending&Search=%E6%90%9C%E5%B0%8B")  
  end 

  # success case in search list by title 
  scenario "list search by title" do
    visit new_task_path
    title = "This is a test"
    content = "This is a test content"
    endtime = ""
    status = 'not_set'
    run_create_task(title: title, content: content, endtime: endtime, task_status: status)  
    visit tasks_path
    fill_in I18n.t('forms.search.title'), with: "This"
    find('input[name="Search"]').click
    expect(page).to have_content("#{title}")  
    expect(page).to have_current_path("/tasks?q[title_cont]=This&q[task_status_eq]=&Search=%E6%90%9C%E5%B0%8B")  
  end 

  # success case in search list by status 
  scenario "list search by status" do  
    visit new_task_path
    title = "This is a test"
    content = "This is a test content"
    endtime = ""
    status = 'inprogress'
    run_create_task(title: title, content: content, endtime: endtime, task_status: status) 
    visit tasks_path
    find("#q_task_status_eq > option[value='inprogress']").select_option
    find('input[name="Search"]').click
    expect(page).to have_content("#{status}")  
    expect(page).to have_current_path("/tasks?q[title_cont]=&q[task_status_eq]=inprogress&Search=%E6%90%9C%E5%B0%8B")  
  end 

  private
    # test create task
    def run_create_task(title:, content:, endtime:, task_status:)
      visit new_task_path
      fill_in I18n.t('forms.field_label.title'), with: title
      fill_in I18n.t('forms.field_label.content'), with: content
      fill_in I18n.t('forms.field_label.endtime'), with: endtime
      find("#task_task_status > option[value='#{task_status}']").select_option
      click_button I18n.t('forms.button.submit')
    end

    # test edit task
    def run_edit_task(title:, content:, endtime:, task_status:)
      task = create(:task)
      visit(edit_task_path(task.id))
      fill_in I18n.t('forms.field_label.title'), with: title
      fill_in I18n.t('forms.field_label.content'), with: content
      fill_in I18n.t('forms.field_label.endtime'), with: endtime
      find("#task_task_status > option[value='#{task_status}']").select_option
      click_button I18n.t('forms.button.submit')
    end

    # test delete task
    def run_delete_task
      task = create(:task)
      visit(task_path(task.id))
      click_button I18n.t('forms.button.destroy')
    end
end
