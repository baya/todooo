# -*- coding: utf-8 -*-
class EventCollection

  include Enumerable
  DEFAULT_LIMIT = 50

  def self.create(params = {})
    team_id  = params[:team_id]
    user_id  = params[:user_id]
    limit    = params[:per_page].to_i
    limit    = DEFAULT_LIMIT if limit <= 0
    page     = params[:page].to_i
    page     = 1 if page <= 0
    offset   = (page - 1) * limit
    
    sql  = build_sql(team_id: team_id,
                     user_id: user_id,
                     offset: offset,
                     limit: limit
                     )
    list = run_sql(sql)
    list = list.map{|attrs| EventItem.new(attrs) }
    new(list)
  end

  def self.build_sql(opts = {})
    team_id = opts[:team_id]
    user_id = opts[:user_id]
    offset  = opts[:offset]
    limit   = opts[:limit]
    
    sql = <<-EOF
      select e.created_at as created_at,
      e.id as event_id,
      e.action as action,
      e.old_deadlines,
      e.new_deadlines,
      e.resource_type,
      e.source_type,
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
      r_proj.name as r_proj_name,
      s_cm.id as s_cm_id,
      s_cm.content as s_cm_content,
      s_cm_todo.id as s_cm_todo_id,
      s_cm_todo.content as s_cm_todo_content,
      r_team.name as r_team_name,
      r_team.id as r_team_id,
      t.id as team_id,
      t.name as team_name
      from events e
      join users u on u.id = e.user_id
      join teams t on t.id = e.team_id
      left join teams r_team on (r_team.id = e.resource_id and e.resource_type = 'Team')
      left join projects r_proj on (r_proj.id = e.resource_id and e.resource_type = 'Project')
      left join todos s_todo on (s_todo.id = e.source_id and e.source_type = 'Todo')
      left join projects s_proj on (s_proj.id = e.source_id and e.source_type = 'Project')
      left join teams s_team on (s_team.id = e.source_id and e.source_type = 'Team')
      left join comments s_cm on (s_cm.id = e.source_id and e.source_type = 'Comment')
      left join todos s_cm_todo on (s_cm_todo.id = s_cm.todo_id)
      left join users old_u on (old_u.id = e.old_assigned_user_id)
      left join users new_u on (new_u.id = e.new_assigned_user_id)
      where e.team_id = #{team_id}
    EOF

    sql << ' and e.user_id = #{user_id}' if user_id.present?
    sql << ' order by created_at desc'
    sql << " limit #{limit} offset #{offset}"

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

  def to_group_data
    data = {}
    each {|item| push_to_container(data, item) }
    data
  end

  def to_hash_group_data
    data = to_group_data
    h = {}
    data.each {|day, cates| h[day] = cates.map(&:to_hash_data) }
    h
  end

  private
  
  # 容器的结构:
  # {
  #   date0 => [category01, category02, ...],
  #   date1 => [category11, category12, ...],
  #   ...
  # }
  def push_to_container(data, item)
    day = item.created_date
    data[day] ||= []
    cate = data[day].detect {|categ|
      index = data[day].index(categ)
      next_categ = data[day][index + 1]
      categ.access?(item) && next_categ.nil?
    }

    if cate
      cate.push(item)
    else
      cate = EventCategory.create_from_item(item)
      data[day] << cate
    end

  end


end
