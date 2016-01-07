class Ability
  include CanCan::Ability
# ↓ 以下を追記
  def initialize(user)
    user ||= User.new # ログインしていない場合は、からユーザーを用意し判定に用いる      
      cannot :read, Dog
      cannot :read, User
      cannot :read, Bookmark
    if user.admin?
      can :manage, Dog
    elsif user.member?
      can :manage, Bookmark, user_id: user.id
      cannot :edit ,Dog
      cannot :destroy ,Dog
      cannot :edit ,User
      cannot :destroy ,User
    end
  end
end