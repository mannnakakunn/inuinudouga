require "flickraw"
 
FlickRaw.api_key = "bac0a9ba36efc0acc5d281d871d431be"
FlickRaw.shared_secret = "a0454904da11ff02"
 
def get_flickr_images(tag)
  thumbnail_size = "m"
  original_size = "z"
 
  images = flickr.photos.search(tags: tag, sort: "relevance", per_page: 20)  
 
  flickr_images = []
  images.each do |image|
    flickr_images << FlickrImage.new(
      id: image["id"],
      title: image["title"],
      description: "",
      link_url: "http://www.flickr.com/photos/#{image["owner"]}/#{image["id"]}",
      thumbnail_url: "http://farm#{image["farm"]}.static.flickr.com/#{image["server"]}/#{image["id"]}_#{image["secret"]}_#{thumbnail_size}.jpg",
      original_url: "http://farm#{image["farm"]}.static.flickr.com/#{image["server"]}/#{image["id"]}_#{image["secret"]}_#{original_size}.jpg"
    )
  end
 
  flickr_images
end
 
class FlickrImage
  def initialize(id:nil, title:nil, description:nil, link_url:nil, thumbnail_url:nil, original_url:nil)
    @id = id
    @title = title
    @description = description
    @link_url = link_url
    @thumbnail_url = thumbnail_url
    @original_url = original_url
  end
 
  attr_accessor :id, :title, :description, :link_url, :thumbnail_url, :original_url
end
 
get_flickr_images("mountain").each do |image|
  puts image.title
  puts image.link_url
end