class Access < ActiveRecord::Base
  belongs_to :project
  belongs_to :member, foreign_key: 'user_id', class_name: 'User'
end
