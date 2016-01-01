module BookmarksHelper
  def bookmark_icon(dog_id, user)
    if user
      if user.bookmarks.exists?(dog_id: dog_id)
        '<i class="fa fa-bookmark fa-2x"></i>お気に入りに登録済み'
      else
        '<i class="fa fa-bookmark fa-bookmark-o fa-2x"></i>この動画をお気に入り登録しますか？'
      end
    end
  end
end