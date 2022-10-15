require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:rack_test)
    Task.destroy_all
  end

  # success case
  scenario "valid title and content" do  
    run_create_task(title: Faker::Lorem.sentence, content: Faker::Lorem.sentence)

    expect(page).to have_content("Task was successfully created")
  end

  # success case
  scenario "valid title and content on edit" do  
    run_edit_task(title: Faker::Lorem.sentence, content: Faker::Lorem.sentence)

    expect(page).to have_content("Task was successfully updated")
  end

  # success case
  scenario "deleted successfully" do  
    run_delete_task
    expect(page).to have_content("Task was successfully destroyed")
  end

  # error case
  scenario "empty title and content" do  
    run_create_task(title: '', content: '')
    run_edit_task(title:'', content: '')

    expect(page).to have_content("Title can't be blank Title is too short (minimum is 5 characters) Content can't be blank Content is too short (minimum is 5 characters)")
  end

  # error case
  scenario "empty title " do       
    run_create_task(title:'', content: Faker::Lorem.sentence)
    run_edit_task(title:'', content: Faker::Lorem.sentence)

    expect(page).to have_content("Title can't be blank Title is too short (minimum is 5 characters)")
  end
  
  # error case
  scenario "empty content " do  
    run_create_task(title: Faker::Lorem.sentence, content: '')
    run_edit_task(title: Faker::Lorem.sentence, content: '')

    expect(page).to have_content("Content can't be blank Content is too short (minimum is 5 characters)")
  end

  private
    # test create task
    def run_create_task(title:, content:)
      visit new_task_path
      fill_in 'Title', with: title
      fill_in 'Content', with: content
      click_button 'Submit'
    end

    # test edit task
    def run_edit_task(title:, content:)
      task = create(:task)
      visit(edit_task_path(task.id))
      fill_in 'Title', with: title
      fill_in 'Content', with: content
      click_button 'Submit'
    end

    # test delete task
    def run_delete_task
      task = create(:task)
      visit(task_path(task.id))
      click_button 'Destroy this task'
    end
end
