class Team < ActiveRecord::Base

  belongs_to :creator, foreign_key: 'creator_id', class_name: 'User'
  has_and_belongs_to_many :members, class_name: 'User'
  has_many :projects
  has_many :events
  has_many :source_events, as: :source, class_name: 'Event'
  has_many :resource_events, as: :resource, class_name: 'Event'
  
end
