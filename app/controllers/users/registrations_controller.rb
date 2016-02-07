class Users::RegistrationsController < Devise::RegistrationsController

# 登録画面に関してのコントローラー
include ApplicationHelper

def new
    @search = Dog.search(params[:q])
end

end