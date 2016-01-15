# -*- coding: utf-8 -*-
class EventCollection

  include Enumerable

  def self.create(params = {})
    sql  = build_sql(params)
    list = run_sql(sql)
    Rails.logger.info("+++++++++#{list.inspect}")
    list = list.map{|attrs|
      Rails.logger.info("???????????????#{attrs.inspect}")
      EventItem.new(attrs)
    }
    new(list)
  end

  def self.create_group_data(params = {})
    create(params).create_group_data
  end

  def self.build_sql(opts = {})
    team_id = opts[:team_id]
    user_id = opts[:user_id]
    
    sql = <<-EOF
      select e.created_at as created_at,
      e.id as event_id,
      e.action as action,
      e.old_deadlines,
      e.new_deadlines,
      e.resource_type,
      u.name as user_name,
      u.id as user_id,
      e.team_id as team_id,
      old_u.name as old_u_name,
      old_u.id as old_u_id,
      new_u.name as new_u_name,
      new_u.id as new_u_id,
      e.old_deadlines as old_deadlinies,
      e.new_deadlines as new_deadlines,
      u.name as user_name,
      u.id   as user_id,
      s_todo.content as todo_content,
      s_todo.id as todo_id,
      s_proj.name as s_proj_name,
      s_proj.id as s_proj_id,
      s_team.name as s_team_name,
      s_team.id as s_team_id,
      r_proj.id as r_proj_id,
      r_proj.name as r_proj_name
      from events e
      join users u on u.id = e.user_id
      join teams t on t.id = e.team_id
      left join teams r_team on (r_team.id = e.resource_id and e.resource_type = 'Team')
      left join projects r_proj on (r_proj.id = e.resource_id and e.resource_type = 'Project')
      left join todos s_todo on (s_todo.id = e.source_id and e.source_type = 'Todo')
      left join projects s_proj on (s_proj.id = e.source_id and e.source_type = 'Project')
      left join teams s_team on (s_team.id = e.source_id and e.source_type = 'Team')
      left join users old_u on (old_u.id = e.old_assigned_user_id)
      left join users new_u on (new_u.id = e.new_assigned_user_id)
      where e.team_id = #{team_id}
    EOF

    sql << ' and e.user_id = #{user_id}' if user_id.present?
    sql << ' order by created_at asc'

    sql
  end

  def self.run_sql(sql)
    obj = Class.new(ActiveRecord::Base)
    sql = obj.send(:sanitize_sql, sql)
    ActiveRecord::Base.connection.select_all(sql)
  end

  def initialize(list = [])
    @list = list
  end

  def each(&block)
    @list.each(&block)
  end

  def create_group_data
    data = {}
    by_created_at_desc = ->(x, y){ y.created_at <=> x.created_at}
    items = sort(&by_created_at_desc)
    items.each {|item| push_to_container(data, item) }

    data
  end

  private
  
  # 容器的结构:
  # {
  #   date => [category1, category_id2, ...] ]
  # }
  def push_to_container(data, item)
    day = item.created_date
    data[day] ||= []
    cate = data[day].detect {|cate|
      match_cate = cate.access?(item)
      
      index = data[day].index(cate)
      next_cate = data[day][index + 1]
      if next_cate.nil?
        match_time = true
      else
        match_time = next_cate.more_last_than?(item)
      end

      match_cate && match_time
    }

    if cate
      cate.push(item)
    else
      cate = EventCategory.create_from_item(item)
      data[day] << cate
    end

  end


end
