# -*- coding: utf-8 -*-
class EventItem

  URL_HELPER = Rails.application.routes.url_helpers
  
  ATTRS = [
           :event_id,
           :created_at,
           :action,
           :old_deadlines,
           :new_deadlines,
	   :resource_type,
           :old_u_name,
           :new_u_name,
           :new_u_id,
           :user_name,
           :user_id,
           :old_deadlines,
           :new_deadlines,
           :user_name,
           :user_id,
           :todo_content,
           :todo_id,
           :s_proj_name,
           :s_proj_id,
           :s_team_name,
           :s_team_id,
           :r_proj_id,
           :r_proj_name,
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

  
end
