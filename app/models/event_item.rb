# -*- coding: utf-8 -*-
class EventItem

  URL_HELPER = Rails.application.routes.url_helpers
  
  ATTRS = [
           :event_id,         # 事件的 id
           :created_at,       # 事件的创建时间
           :action,           # 事件的 action
           :team_id,          # 事件所属的团队 id
           :team_name,        # 事件所属的团队名
           :source_type,      # 事件来源的类型
	   :resource_type,    # 事件所属的资源的类型
           :old_u_id,         # 事件的 todo 的旧的指派者的 id
           :old_u_name,       # 事件的 todo 的旧的指派者的 name
           :new_u_name,       # 事件的 todo 的新的指派者的 name
           :new_u_id,         # 事件的 todo 的新的指派者的 id
           :old_deadlines,    # 事件的 todo 的旧的截止日期
           :new_deadlines,    # 事件的 todo 的新的截止日期
           :user_name,        # 事件的触发者的 name
           :user_id,          # 事件的触发者的 id
           :todo_content,     # 事件来源的 todo 的内容
           :todo_id,          # 事件来源的 todo 的 id
           :s_proj_name,      # 事件来源的 project 的 name
           :s_proj_id,        # 事件来源的 project 的 id
           :s_team_name,      # 事件来源的 team 的 name
           :s_team_id,        # 事件来源的 team 的 id
           :r_proj_id,        # 事件所属的 project 的 id
           :r_proj_name,      # 事件所属的 project 的 name
           :r_team_id,        # 事件所属的 team 的 id
           :r_team_name,      # 事件所属的 team
           :s_cm_id,          # 评论的 id
           :s_cm_content,     # 评论的内容
           :s_cm_todo_id,     # 评论的任务的 id
           :s_cm_todo_content # 评论的任务的内容
          ].freeze

  ATTRS.each do |attr|
    attr_reader attr
  end

  def initialize(attrs = {})
    attrs.each {|name, value|
      if ATTRS.include?(name.to_sym)
        instance_variable_set("@#{name}", value)
      end
    }

    @created_at = @created_at.to_datetime
  end

  def created_date
    @created_date ||= @created_at.to_date
  end

  def category_id
    @category_id ||= [r_proj_id, r_team_id].select(&:present?)[0].to_i
  end

  def category_name
    @category_name ||= [r_proj_name, r_team_name].select(&:present?)[0]
  end

  def resource_name
    @resource_name ||= resource_type.to_s.downcase
  end

  def created_hm
    created_at.strftime('%H:%M')
  end

  def todo_path
    URL_HELPER.todo_path(r_proj_id, todo_id)
  end

  def pretty_old_deadlines
    pretty_deadlines(old_deadlines)
  end

  def pretty_new_deadlines
    pretty_deadlines(new_deadlines)
  end

  def pretty_deadlines(date = nil)
    if date.blank?
      '没有截止日期'
    else
      PrettyDay.new(date).to_deadlines
    end
  end

  # 评论的任务的 url 路径
  def s_cm_todo_path
    URL_HELPER.todo_path(r_proj_id, s_cm_todo_id)
  end

  # 评论的 url 路径
  def s_cm_path
    "#{s_cm_todo_path}##{s_cm_id}"
  end

  def to_hash_data
    h = {}
    ATTRS.each do |attr|
      h[attr] = send(attr)
    end
    h['created_hm'] = created_hm

    h
  end

  
end
