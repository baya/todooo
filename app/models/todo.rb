# -*- coding: utf-8 -*-
class Todo < ActiveRecord::Base

  STATE_MAP = {
    init:       0,
    running:    1,
    suspend:    2,
    completed:  3,
    deleted:    4,
    recovered:  5
  }.freeze

  STATE_TXT_MAP = {
    0 => '未分配',
    1 => '进行中',
    2 => '挂起',
    3 => '完成',
    4 => '删除',
    5 => '恢复'
  }.freeze

  belongs_to :creator, foreign_key: 'creator_id', class_name: 'User'
  belongs_to :assigned_user, foreign_key: 'assigned_user_id', class_name: 'User'
  belongs_to :project
  has_many :source_events, as: :source, class_name: 'Event'

  validates :content, presence: true, length: { maximum: 1000 }


  def state_txt
    STATE_TXT_MAP[state]
  end

  def deleted?
    state == STATE_MAP.fetch(:deleted)
  end
  
end
