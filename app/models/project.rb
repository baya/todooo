class Project < ActiveRecord::Base

  belongs_to :creator, foreign_key: 'creator_id', class_name: 'User'
  belongs_to :team
  has_many :accesses
  has_many :members, through: :accesses
  has_many :todos
  has_many :source_events, as: :source
  has_many :events, as: :resource

end
