class Users::SessionsController < Devise::SessionsController

before_filter :custom_method, :only => [:index ,:new, :edit, :create, :destroy]

def custom_method
  authenticate_user!

  if current_user.admin?
     return
  elsif current_user.member?
     redirect_to root_url # or whatever
  end
end

end