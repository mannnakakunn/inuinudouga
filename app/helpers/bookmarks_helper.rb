module BookmarksHelper
  def bookmark_icon(dog_id, user)
    if user
      if user.bookmarks.exists?(dog_id: dog_id)
        '<i class="fa fa-bookmark fa-2x"></i>'
      else
        '<i class="fa fa-bookmark fa-bookmark-o fa-2x"></i>'
      end
    end
  end
end