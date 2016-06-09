class Group < ActiveRecord::Base
  has_many :members
  has_many :albums
  has_many :songs, through: :albums
end

class Member < ActiveRecord::Base
  belongs_to :group
end

class Album < ActiveRecord::Base
  belongs_to :group
end

class Song < ActiveRecord::Base
  belongs_to :album
  delegate :group, :to => :album
end
