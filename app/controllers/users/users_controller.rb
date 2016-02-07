class UsersController < ApplicationController

include ApplicationHelper

  def index
    @search = Dog.search(params[:q])
    @users = User.all
    @bookmark=Bookmark.all
    @tags = Dog.tag_counts_on(:tags).order('count DESC')
  end
 
  def show
    @search = Dog.search(params[:q])
    @user = User.find(params[:id])
    @bookmark=Bookmark.all
    @dog=Dog.all
    @tags = Dog.tag_counts_on(:tags).order('count DESC')
  end

end