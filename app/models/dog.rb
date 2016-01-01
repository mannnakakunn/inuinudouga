class Dog < ActiveRecord::Base
acts_as_taggable_on :tag_name
# attr_accessible :tag_name
acts_as_taggable            # acts_as_taggable_on :tags のエイリアス
has_many :bookmarks
has_many :users, through: :bookmarks
end
