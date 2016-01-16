class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :todo
  has_many :source_events, as: :source, class_name: 'Event'
  
  validates :content, presence: true

end
