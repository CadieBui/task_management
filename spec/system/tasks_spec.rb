require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:rack_test)
  end
  
  # success case
  scenario "valid title and content" do  
    if Task.exists?(title: Faker::Lorem.sentence) || Task.exists?(content: Faker::Lorem.sentence)
      run_create_task(title: Faker::Lorem.sentence(word_count: 10), content: Faker::Lorem.sentence(word_count: 10))
      expect(page).to have_content("Task was successfully created")
    else
      run_create_task(title: Faker::Lorem.sentence, content: Faker::Lorem.sentence)
      expect(page).to have_content("Task was successfully created")
    end
  end

  # error case
  scenario "empty title and content" do  
    run_create_task(title: '', content: '')
    expect(page).to have_content("Title can't be blank Title is too short (minimum is 5 characters) Content can't be blank Content is too short (minimum is 5 characters)")
  end

  # error case
  scenario "empty title " do   
    visit tasks_path
    click_link "New"
    fill_in 'Title', with: ''
    click_button 'Submit'
    expect(page).to have_content("Title can't be blank Title is too short (minimum is 5 characters)")
  end
  
  # error case
  scenario "empty content " do  
    visit tasks_path
    click_link "New"
    fill_in 'Content', with: ''
    click_button 'Submit'
    expect(page).to have_content("Content can't be blank Content is too short (minimum is 5 characters)")
  end

  private
    def run_create_task(title:, content:)
      visit tasks_path
      click_link "New"
      fill_in 'Title', with: title
      fill_in 'Content', with: content
      click_button 'Submit'
    end

end
