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
        tr.all('td').map(&:text)
      end
      r = [
        [task2.title, task2.content, I18n.t("forms.enum.status_enum.#{task2.status}"), I18n.t("forms.enum.priority_enum.#{task2.priority}"), '', ''], 
        [task1.title, task1.content, I18n.t("forms.enum.status_enum.#{task1.status}"), I18n.t("forms.enum.priority_enum.#{task1.priority}"), '', '']
      ]
      expect(page).to have_current_path("/tasks?q%5Bs%5D=created_at+desc")
      expect(task).to eq(r)
    end
  end

  describe 'search flow' do
    let!(:tag) { create(:tag) }
    let!(:task) { create(:task, title: "This is title", status: 'pending', priority: 'high', tag_ids: tag.id, user_id: user.id) }
    
    let(:not_search) { { title: '', status: '', priority: '', tag_ids: ''}}
    let(:search_all) { { title: "This is title", status: 'pending', priority: 'high', tag_ids: tag.id} }
    let(:search_title) { { title: "This is title", status: '', priority: '', tag_ids: ''} }
    let(:search_priority) { { title: '', status: '', priority: 'high', tag_ids: ''} }
    let(:search_status) { { title: '', status: 'pending', priority: '', tag_ids: ''} }
    let(:search_status_priority) { { title: '', status: 'pending', priority: 'high', tag_ids: ''} }
    let(:search_title_status) { { title: "This is title", status: 'pending', priority: '', tag_ids: ''} }
    let(:search_title_priority) { { title: "This is title", status: '', priority: 'high', tag_ids: ''} }
    let(:search_tag) { { title: '', status: '', priority: '', tag_ids: tag.id} }
    let(:search_tag_title) { { title: 'This is title', status: '', priority: '', tag_ids: tag.id} }
    let(:search_tag_priority) { { title: '', status: '', priority: 'high', tag_ids: tag.id} }
    let(:search_tag_status) { { title: '', status: 'pending', priority: '', tag_ids: tag.id} }
    
    it "success" do
      visit tasks_path
      run_fill_search(search_all)
      expect(page).to have_content("#{task.title}")
      run_expect(search_all, task)
      expect(page).to have_current_path("/tasks?q[title_cont]=This+is+title&q[status_eq]=#{search_all[:status]}&q[priority_eq]=#{search_all[:priority]}&q[tags_id_eq]=#{search_all[:tag_ids]}&Search=%E6%90%9C%E5%B0%8B")
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
        run_expect(search_status_priority, task)
        expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=#{search_status_priority[:status]}&q[priority_eq]=#{search_status_priority[:priority]}&q[tags_id_eq]=&Search=%E6%90%9C%E5%B0%8B")
      end
    end

    context 'when search empty status' do
      it do
        run_fill_search(search_title_priority)
        run_expect(search_title_priority, task)
        expect(page).to have_current_path("/tasks?q[title_cont]=This+is+title&q[status_eq]=&q[priority_eq]=#{search_title_priority[:priority]}&q[tags_id_eq]=&Search=%E6%90%9C%E5%B0%8B")
      end
    end

    context 'when search empty priority' do
      it do
        visit tasks_path
        run_fill_search(search_title_status)
        run_expect(search_title_status, task)
        expect(page).to have_current_path("/tasks?q[title_cont]=This+is+title&q[status_eq]=#{search_status_priority[:status]}&q[priority_eq]=&q[tags_id_eq]=&Search=%E6%90%9C%E5%B0%8B")
      end
    end

    context 'when search empty priority and title' do
      it do
        visit tasks_path
        run_fill_search(search_status)
        run_expect(search_status, task)
        expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=#{search_status[:status]}&q[priority_eq]=&q[tags_id_eq]=&Search=%E6%90%9C%E5%B0%8B")
      end
    end

    context 'when search empty priority and status' do
      it do
        visit tasks_path
        run_fill_search(search_title)
        run_expect(search_title, task)
        expect(page).to have_current_path("/tasks?q[title_cont]=This+is+title&q[status_eq]=&q[priority_eq]=&q[tags_id_eq]=&Search=%E6%90%9C%E5%B0%8B")
      end
    end

    context 'when search empty title and status' do
      it do
        visit tasks_path
        run_fill_search(search_priority)
        run_expect(search_priority, task)
        expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=&q[priority_eq]=#{search_priority[:priority]}&q[tags_id_eq]=&Search=%E6%90%9C%E5%B0%8B")
      end
    end

    context 'when search empty title and status and priority' do
      it do
        visit tasks_path
        run_fill_search(search_tag)
        run_expect(search_tag, task)
        expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=&q[priority_eq]=&q[tags_id_eq]=#{search_tag[:tag_ids]}&Search=%E6%90%9C%E5%B0%8B")
      end
    end

    context 'when search empty status and priority' do
      it do
        visit tasks_path
        run_fill_search(search_tag_title)
        run_expect(search_tag_title, task)
        expect(page).to have_current_path("/tasks?q[title_cont]=This+is+title&q[status_eq]=&q[priority_eq]=&q[tags_id_eq]=#{search_tag_title[:tag_ids]}&Search=%E6%90%9C%E5%B0%8B")
      end
    end

    context 'when search empty status and title' do
      it do
        visit tasks_path
        run_fill_search(search_tag_priority)
        run_expect(search_tag_priority, task)
        expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=&q[priority_eq]=#{search_tag_priority[:priority]}&q[tags_id_eq]=#{search_tag_priority[:tag_ids]}&Search=%E6%90%9C%E5%B0%8B")
      end
    end

    context 'when search empty priority and title' do
      it do
        visit tasks_path
        run_fill_search(search_tag_status)
        run_expect(search_tag_status, task)
        expect(page).to have_current_path("/tasks?q[title_cont]=&q[status_eq]=#{search_tag_status[:status]}&q[priority_eq]=&q[tags_id_eq]=#{search_tag_status[:tag_ids]}&Search=%E6%90%9C%E5%B0%8B")
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
      find("#q_priority_eq > option[value=#{task[:priority]}]").select_option
    end

    if task[:tag_ids] != ''
      find("#q_tags_id_eq > option[value=#{task[:tag_ids]}]").select_option
    end

    find('input[name="Search"]').click
  end

  def run_expect(search_task, task)
    # debugger
    if search_task[:title] != ''
      expect(page).to have_content("#{search_task[:title]}")
    end
    if search_task[:status] != ''
      expect(page).to have_content(I18n.t("forms.enum.status_enum.#{search_task[:status]}"))
    end
    if search_task[:priority] != ''
      expect(page).to have_content(I18n.t("forms.enum.priority_enum.#{search_task[:priority]}"))
    end
    if search_task[:tag_ids] != ''
      tags = task.tags.map { |d|  d.tagname}.join(', ')
      expect(page).to have_content(tags.to_s)
    end
  end
end
