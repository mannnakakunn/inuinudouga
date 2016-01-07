class Admin::BaseController < ApplicationController

  before_filter :authenticate_user!

  def index
  end

   def current_ability
    @current_ability ||= Ability.new(current_user)
  end

end
