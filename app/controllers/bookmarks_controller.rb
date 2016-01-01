class BookmarksController < ApplicationController
  def toggle
    dog_id = params[:dog_id]
    user_bookmarks = current_user.bookmarks
    if user_bookmarks.exists?(dog_id: dog_id)
      user_bookmarks.where(dog_id: dog_id).destroy_all
    else
      user_bookmarks.create(user: current_user, dog: Dog.find(dog_id))
    end
    render :nothing => true
  end
end
