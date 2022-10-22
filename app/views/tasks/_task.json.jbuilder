json.extract! task, :id, :title, :content, :created_at, :updated_at, :endtime, :task_status
json.url task_url(task, format: :json)
