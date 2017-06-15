json.extract! question, :id, :title, :description, :created_at, :updated_at
json.url question_url(question, format: :json)
