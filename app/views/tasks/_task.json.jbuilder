json.extract! task, :id, :title, :content, :created_at, :updated_at, :endtime, :status, :priority, :tag_ids
json.url task_url(task, format: :json)
