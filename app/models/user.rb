class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #追加
  has_many :bookmarks
  has_many :dogs, through: :bookmarks
  enum role: {admin: "admin", member: "member"}
  # enum role: {admin: 'admin', member: 'member'}
end