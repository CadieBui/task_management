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
    expect(page).to have_content I18n.t(:successfully_create)
    expect(Task.find_by(title: title, content: content)).to be_present
  end

  # success case in edit
  scenario "valid title and content in edit" do  
    title = Faker::Lorem.sentence
    content = Faker::Lorem.sentence
    run_edit_task(title: title, content: content)
    expect(page).to have_content I18n.t(:successfully_update)
    expect(Task.find_by(title: title, content: content)).to be_present
  end

  # success case in delete
  scenario "deleted successfully" do  
    run_delete_task
    expect(page).to have_content I18n.t(:successfully_delete)
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

  private
    # test create task
    def run_create_task(title:, content:)
      visit new_task_path
      fill_in I18n.t(:title), with: title
      fill_in I18n.t(:content), with: content
      click_button I18n.t(:submit)
    end

    # test edit task
    def run_edit_task(title:, content:)
      task = create(:task)
      visit(edit_task_path(task.id))
      fill_in I18n.t(:title), with: title
      fill_in I18n.t(:content), with: content
      click_button I18n.t(:submit)
    end

    # test delete task
    def run_delete_task
      task = create(:task)
      visit(task_path(task.id))
      click_button I18n.t(:destroy)
    end
end
