require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:rack_test)
    Task.destroy_all
  end

  # success case in create
  scenario "valid title and content in create" do  
    title = Faker::Lorem.sentence
    content = Faker::Lorem.sentence
    run_create_task(title: title, content: content)
    expect(page).to have_content I18n.t('forms.create.success')
    expect(Task.find_by(title: title, content: content)).to be_present
  end

  # success case in edit
  scenario "valid title and content in edit" do  
    title = Faker::Lorem.sentence
    content = Faker::Lorem.sentence
    run_edit_task(title: title, content: content)
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
    run_edit_task(title:'', content: '')
    expect(page).to have_content("error")
  end

  # error case in create
  scenario "empty title in create " do       
    content = Faker::Lorem.sentence
    run_create_task(title:'', content: content)
    expect(page).to have_content('error')

  end

  # error case in create
  scenario "empty content in create " do  
    title = Faker::Lorem.sentence
    run_create_task(title: title, content: '')
    expect(page).to have_content("error")

  end

  # error case in edit
  scenario "empty title and content in edit" do  
    run_edit_task(title:'', content: '')
    expect(page).to have_content("error")
  end

  # error case in edit
  scenario "empty title in edit " do       
    content = Faker::Lorem.sentence
    run_edit_task(title:'', content: content)
    expect(page).to have_content("error")
  end

  # error case in edit
  scenario "empty content in edit " do  
    title = Faker::Lorem.sentence
    run_edit_task(title: title, content: '')
    expect(page).to have_content("error")
  end 

  # success case in show list sort by create time
  scenario "list sort by create time " do  
    task_old_title = "This is a old task title"
    task_old_content = "This is a old task content"
    task_new_title = "This is a new task title"
    task_new_content = "This is a new task content"
    run_create_task(title: task_old_title, content: task_old_content)
    run_create_task(title: task_new_title, content: task_new_content)
    visit tasks_path
    expect(page).to have_content("#{task_new_title} #{task_new_content} #{task_old_title} #{task_old_content}")
  end 

  private
    # test create task
    def run_create_task(title:, content:)
      visit new_task_path
      fill_in I18n.t('forms.field_label.title'), with: title
      fill_in I18n.t('forms.field_label.content'), with: content
      click_button I18n.t('forms.button.submit')
    end

    # test edit task
    def run_edit_task(title:, content:)
      task = create(:task)
      visit(edit_task_path(task.id))
      fill_in I18n.t('forms.field_label.title'), with: title
      fill_in I18n.t('forms.field_label.content'), with: content
      click_button I18n.t('forms.button.submit')
    end

    # test delete task
    def run_delete_task
      task = create(:task)
      visit(task_path(task.id))
      click_button I18n.t('forms.button.destroy')
    end
end
