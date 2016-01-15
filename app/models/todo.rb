class Todo < ActiveRecord::Base

  STATE_MAP = {
    init:      0,
    running:   1,
    suspend:   2,
    completd:  3,
    deleted:   4,
    recovered: 5
  }.freeze

  belongs_to :creator, foreign_key: 'creator_id', class_name: 'User'
  belongs_to :assigned_user, foreign_key: 'assigned_user_id', class_name: 'User'
  belongs_to :project
  has_many :source_events, as: :source, class_name: 'Event'

  validates :content, presence: true, length: { maximum: 1000 }
  
end
