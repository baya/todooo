class User < ActiveRecord::Base

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :email, uniqueness: true

  has_many :created_teams, foreign_key: 'creator_id', class_name: 'Team'
  has_many :created_projects, foreign_key: 'creator_id', class_name: 'Project'
  has_many :accesses
  has_many :projects, through: :accesses
  has_many :todos
  has_and_belongs_to_many :teams
  has_many :events
  
end
