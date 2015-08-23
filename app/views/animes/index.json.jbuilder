json.array!(@animes) do |anime|
  json.extract! anime, :id, :title, :days_of_the_week, :start_time
  json.url anime_url(anime, format: :json)
end
