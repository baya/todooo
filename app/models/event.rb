# -*- coding: utf-8 -*-
class Event < ActiveRecord::Base

  VALID_ACTION_LIST = [
                       :create_todo,         # 创建任务
                       :edit_todo_deadlines, # 修改截至日期
                       :create_project,      # 创建项目
                       :start_todo,          # 开始处理任务
                       :reopen_todo,         # 重新打开任务
                       :complete_todo,       # 完成任务
                       :suspend_todo,        # 暂停处理任务
                       :reply_todo_list,     # 回复任务清单
                       :create_todo_list,    # 创建任务清单
                       :move_todo,           # 移动任务
                       :comment_todo,        # 评论任务
                       :assign_todo,         # 指派任务,
                       :edit_assign_todo,    # 修改任务完成者
                       :create_team,         # 创建了团队
                       :praise_comment,      # 赞了评论
                       :delete_comment,      # 删除回复
                       :delete_todo,         # 删除任务
                       :recover_todo,        # 恢复任务
                       :create_schedule,     # 创建日程
                       :edit_schedule,       # 编辑日程
                       :delete_schedule      # 删除日程
                      ].map(&:to_s).freeze

  # 事件发生时所属的源，比如 project, todo, 日程等
  belongs_to :source, polymorphic: true

  # 事件所属的资源，比如 team, project, calendar
  belongs_to :resource, polymorphic: true
  
  belongs_to :user
  belongs_to :team

  validates :action, inclusion: {in: VALID_ACTION_LIST}
  validates :action, presence: true

end
