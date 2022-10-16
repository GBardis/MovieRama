json.extract! movie, :id, :title, :description, :user_name, :likes, :hates, :created_at, :updated_at
json.url movie_url(movie, format: :json)
