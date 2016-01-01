json.array!(@dogs) do |dog|
  json.extract! dog, :id, :name, :title, :description, :genre, :length, :watch, :fav, :mvid, :url
  json.url dog_url(dog, format: :json)
end
