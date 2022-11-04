require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:password) { '1234' }
  let!(:user) { create(:user, password: password) }
  before do
    driven_by(:rack_test)
    Task.destroy_all
    run_login(user.username, password)
  end

  describe 'create flow' do
    let(:task) { build(:task, status: 'pending', priority: 'high') }
    
    it "success" do
      run_create_task(task)
      expect(page).to have_content I18n.t('forms.create.success')
      attrs = task.attributes.symbolize_keys.slice(:title, :content, :status, :priority).merge(user_id: user.id)
      expect(Task.find_by(attrs)).to be_present
    end
  end

  describe 'edit flow' do
    let(:task) { create(:task, status: 'pending', priority: 'high', user_id: user.id) }
    let(:update_task)  { {title: 'This is a new title', content: 'This is a new content', status: 'completed', priority: 'high'} } 

    it "success" do
      run_edit_task(task, update_task)
      expect(page).to have_content I18n.t('forms.edit.success')
      expect(Task.find_by(update_task.merge(user_id: user.id))).to be_present
    end
  end

  describe 'sort flow' do
    let!(:task1) { create(:task, title: "A title", content: "A content", status: 'not_set', priority: 'low', endtime: nil, user_id: user.id) }
    let!(:task2) { create(:task, title: "B title", content: "B content", status: 'pending', priority: 'high', endtime: nil, user_id: user.id) }

    it "success" do
      visit tasks_path
      click_link I18n.t('sort.created_at')
      task = all('tbody > tr').map do |tr|
        tr.all('td').map do |td|
          td.text
        end
      end
      r = [
        [task2.title, task2.content, I18n.t("forms.enum.status_enum.#{task2.status}"), I18n.t("forms.enum.priority_enum.#{task2.priority}"), ''], 
        [task1.title, task1.content, I18n.t("forms.enum.status_enum.#{task1.status}"), I18n.t("forms.enum.priority_enum.#{task1.priority}"), '']
      ]
      expect(page).to have_current_path("/tasks?q%5Bs%5D=created_at+desc")
      expect(task).to eq(r)
    end
  end

  describe 'search flow' do
    let!(:task) { create(:task, title: "This is title", status: 'pending', priority: 'high', user_id: user.id) }
    let(:not_search) { { title: '', status: '', priority: ''}}
    let(:search_all) { { title: "This is title", status: 'pending', priority: 'high'}}
    let(:search_title) { { title: "This is title", status: '', priority: ''}}
    let(:search_priority) { { title: '', status: '', priority: 'high'}}
    let(:search_status) { { title: '', status: 'pending', priority: ''}}
    let(:search_status_priority) { { title: '', status: 'pending', priority: 'high'}}
    let(:search_title_status) { { title: "This is title", status: 'pending', priority: ''}}
    let(:search_title_priority) { { title: "This is title", status: '', priority: 'high'}}

    it "success" do
      visit tasks_path
      run_fill_search(search_all)
      expect(page).to have_content("#{task.title}")
      expect(page).to have_content(I18n.t("forms.enum.status_enum.#{task.status}"))
      expect(page).to have_content(I18n.t("forms.enum.priority_enum.#{task.priority}"))
      expect(page).to have_current_path("/tasks?q[title_cont]=This+is+title&q[status_eq]=#{task.status}&q[priority_eq]=#{task.priority}&Search=%E6%90%9C%E5%B0%8B")
    end

    context 'when search all empty' do
      it do
        run_fill_search(not_search)
        visit tasks_path
        expect(page).to have_content("#{task.title}")
        expect(page).to have_content(I18n.t("forms.enum.status_enum.#{task.status}"))
        expect(page).to have_content(I18n.t("forms.enum.priority_enum.#{task.priority}"))
        expect(page).to have_current_path("/tasks")
      end
    end

    context 'when search empty title' do
      it do
        visit tasks_path
        run_fill_search(search_status_priority)
        expect(page).to have_content(I18n.t("forms.enum.status_enum.#{search_status_priority[:status]}"))
        expect(page).to have_content(I18n.t("forms.enum.priority_enum.#{search_status_priority[:priority]}"))
        expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=#{search_status_priority[:status]}&q[priority_eq]=#{search_status_priority[:priority]}&Search=%E6%90%9C%E5%B0%8B")
      end
    end

    context 'when search empty status' do
      it do
        run_fill_search(search_title_priority)
        expect(page).to have_content("#{search_title_priority[:title]}")
        expect(page).to have_content(I18n.t("forms.enum.priority_enum.#{search_title_priority[:priority]}"))
        expect(page).to have_current_path("/tasks?q[title_cont]=This+is+title&q[status_eq]=&q[priority_eq]=#{search_title_priority[:priority]}&Search=%E6%90%9C%E5%B0%8B")
      end
    end

    context 'when search empty priority' do
      it do
        visit tasks_path
        run_fill_search(search_title_status)
        expect(page).to have_content("#{search_title_priority[:title]}")
        expect(page).to have_content(I18n.t("forms.enum.status_enum.#{search_status_priority[:status]}"))
        expect(page).to have_current_path("/tasks?q[title_cont]=This+is+title&q[status_eq]=#{search_status_priority[:status]}&q[priority_eq]=&Search=%E6%90%9C%E5%B0%8B")
      end
    end

    context 'when search empty priority and title' do
      it do
        visit tasks_path
        run_fill_search(search_status)
        expect(page).to have_content(I18n.t("forms.enum.status_enum.#{search_status[:status]}"))
        expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=#{search_status[:status]}&q[priority_eq]=&Search=%E6%90%9C%E5%B0%8B")
      end
    end

    context 'when search empty priority and status' do
      it do
        visit tasks_path
        run_fill_search(search_title)
        expect(page).to have_content("#{search_title[:title]}")
        expect(page).to have_current_path("/tasks?q[title_cont]=This+is+title&q[status_eq]=&q[priority_eq]=&Search=%E6%90%9C%E5%B0%8B")
      end
    end

    context 'when search empty title and status' do
      it do
        visit tasks_path
        run_fill_search(search_priority)
        expect(page).to have_content(I18n.t("forms.enum.priority_enum.#{search_priority[:priority]}"))
        expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=&q[priority_eq]=#{search_priority[:priority]}&Search=%E6%90%9C%E5%B0%8B")
      end
    end
  end

  describe 'delete flow' do
    let(:task) { create(:task, status: 'pending', priority: 'high', user_id: user.id) }

    it 'success' do
      run_delete_task(task)
      expect(page).to have_content I18n.t('forms.delete.success')
    end
  end

  private

  # create task
  def run_create_task(task)
    visit new_task_path
    fill_in I18n.t('forms.field_label.title'), with: task.title
    fill_in I18n.t('forms.field_label.content'), with: task.content
    fill_in I18n.t('forms.field_label.endtime'), with: task.endtime
    find("#task_status > option[value='#{task.status}']").select_option
    find("#task_priority > option[value='#{task.priority}']").select_option
    click_button I18n.t('forms.button.submit')
  end

  # edit task
  def run_edit_task(task, update_task)
    visit edit_task_path(task.id)
    fill_in I18n.t('forms.field_label.title'), with: update_task[:title]
    fill_in I18n.t('forms.field_label.content'), with: update_task[:content]
    fill_in I18n.t('forms.field_label.endtime'), with: update_task[:endtime]
    find("#task_status > option[value='#{update_task[:status]}']").select_option
    find("#task_priority > option[value='#{update_task[:priority]}']").select_option
    click_button I18n.t('forms.button.submit')
  end

  # delete task
  def run_delete_task(task)
    visit task_path(task)
    click_button I18n.t('forms.button.destroy')
  end

  # login
  def run_login(username, password)
    visit login_path
    fill_in I18n.t('forms.field_label.username'), with: username
    fill_in I18n.t('forms.field_label.password'), with: password
    click_button I18n.t('forms.button.login')
  end

  def run_fill_search(task)
    fill_in I18n.t('forms.search.title'), with: task[:title]

    if task[:status] != ''
      find("#q_status_eq > option[value=#{task[:status]}]").select_option
    end

    if task[:priority] != ''
      find("#q_priority_eq> option[value=#{task[:priority]}]").select_option
    end

    find('input[name="Search"]').click
  end
end
