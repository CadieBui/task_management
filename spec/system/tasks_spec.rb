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
    it "success" do
      run_edit_task(task)
      attrs = task.attributes.symbolize_keys.slice(:title, :content, :status, :priority).merge(user_id: user.id)
      expect(page).to have_content I18n.t('forms.edit.success')
      expect(Task.find_by(attrs)).to be_present
    end
  end

  describe 'sort flow' do
    it "success" do
      visit tasks_path
      click_link I18n.t('sort.created_at')
      expect(page).to have_current_path("/tasks?q%5Bs%5D=created_at+desc")
    end
  end

  describe 'search flow' do
    let(:task) { create(:task, title: "This is title", status: 'pending', priority: 'high', user_id: user.id) }
    it "success" do
      run_create_task(task)
      visit tasks_path
      fill_in I18n.t('forms.search.title'), with: "This"
      find("#q_status_eq > option[value=#{task.status}]").select_option
      find("#q_priority_eq> option[value=#{task.priority}]").select_option
      find('input[name="Search"]').click
      expect(page).to have_content("#{task.title}")
      expect(page).to have_content(I18n.t("forms.enum.status_enum.#{task.status}"))
      expect(page).to have_content(I18n.t("forms.enum.priority_enum.#{task.priority}"))
      expect(page).to have_current_path("/tasks?q[title_cont]=This&q[status_eq]=pending&q[priority_eq]=high&Search=%E6%90%9C%E5%B0%8B")
    end

    context 'when search empty' do
      it 'all' do
        run_create_task(task)
        visit tasks_path
        expect(page).to have_current_path("/tasks")
      end

      it 'title' do
        run_create_task(task)
        visit tasks_path
        find("#q_status_eq > option[value=#{task.status}]").select_option
        find("#q_priority_eq> option[value=#{task.priority}]").select_option
        find('input[name="Search"]').click
        expect(page).to have_content(I18n.t("forms.enum.status_enum.#{task.status}"))
        expect(page).to have_content(I18n.t("forms.enum.priority_enum.#{task.priority}"))
        expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=pending&q[priority_eq]=high&Search=%E6%90%9C%E5%B0%8B")
      end

      it 'status' do
        run_create_task(task)
        visit tasks_path
        fill_in I18n.t('forms.search.title'), with: "This"
        find("#q_priority_eq> option[value=#{task.priority}]").select_option
        find('input[name="Search"]').click
        expect(page).to have_content("#{task.title}")
        expect(page).to have_content(I18n.t("forms.enum.priority_enum.#{task.priority}"))
        expect(page).to have_current_path("/tasks?q[title_cont]=This&q[status_eq]=&q[priority_eq]=high&Search=%E6%90%9C%E5%B0%8B")
      end

      it 'priority' do
        run_create_task(task)
        visit tasks_path
        fill_in I18n.t('forms.search.title'), with: "This"
        find("#q_status_eq > option[value=#{task.status}]").select_option
        find('input[name="Search"]').click
        expect(page).to have_content("#{task.title}")
        expect(page).to have_content(I18n.t("forms.enum.status_enum.#{task.status}"))
        expect(page).to have_current_path("/tasks?q[title_cont]=This&q[status_eq]=pending&q[priority_eq]=&Search=%E6%90%9C%E5%B0%8B")
      end

      it 'priority and title' do
        run_create_task(task)
        visit tasks_path
        find("#q_status_eq > option[value=#{task.status}]").select_option
        find('input[name="Search"]').click
        expect(page).to have_content(I18n.t("forms.enum.status_enum.#{task.status}"))
        expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=pending&q[priority_eq]=&Search=%E6%90%9C%E5%B0%8B")
      end

      
      it 'priority and status' do
        run_create_task(task)
        visit tasks_path
        fill_in I18n.t('forms.search.title'), with: "This"
        find('input[name="Search"]').click
        expect(page).to have_content("#{task.title}")
        expect(page).to have_current_path("/tasks?q[title_cont]=This&q[status_eq]=&q[priority_eq]=&Search=%E6%90%9C%E5%B0%8B")
      end

      it 'title and status' do
        run_create_task(task)
        visit tasks_path
        find("#q_priority_eq> option[value=#{task.priority}]").select_option
        find('input[name="Search"]').click
        expect(page).to have_content(I18n.t("forms.enum.priority_enum.#{task.priority}"))
        expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=&q[priority_eq]=high&Search=%E6%90%9C%E5%B0%8B")
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
  def run_edit_task(task)
    visit edit_task_path(task.id)
    fill_in I18n.t('forms.field_label.title'), with: task.title
    fill_in I18n.t('forms.field_label.content'), with: task.content
    fill_in I18n.t('forms.field_label.endtime'), with: task.endtime
    find("#task_status > option[value='#{task.status}']").select_option
    find("#task_priority > option[value='#{task.priority}']").select_option
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
end
