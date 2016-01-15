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
           :r_team_id,
           :r_team_name
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

  
end
