class UsersController < ApplicationController
  def index
    @users = User.all
    @bookmark=Bookmark.all
    @tags = Dog.tag_counts_on(:tags).order('count DESC')
  end
 
  def show
    @user = User.find(params[:id])
    @bookmark=Bookmark.all
    @dog=Dog.all
    @tags = Dog.tag_counts_on(:tags).order('count DESC')
  end
end