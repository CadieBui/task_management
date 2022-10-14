require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:rack_test)
  end
  
  # success case
  scenario "valid title and content" do  
    visit tasks_path
    click_link "New"
    fill_in 'Title', with: Faker::Lorem.sentence 
    fill_in 'Content', with: Faker::Lorem.sentence 
    click_button 'Submit'
    expect(page).to have_content("Task was successfully created")
  end

  # error case
  scenario "empty title and content" do  
    visit tasks_path
    click_link "New"
    fill_in 'Title', with: ''
    fill_in 'Content', with: ''
    click_button 'Submit'
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
end
