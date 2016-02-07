class Users::SessionsController < Devise::SessionsController
# ログイン画面を表示するコントローラー
  def new
  	build_resource({})
    @search = Dog.search(params[:q])
  end

  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

end