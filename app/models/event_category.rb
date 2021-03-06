# -*- coding: utf-8 -*-
class EventCategory

  InvalidCategoryID = Class.new(StandardError)
  URL_HELPER = Rails.application.routes.url_helpers
  
  attr_reader :id
  attr_reader :name
  attr_reader :resource
  attr_reader :items

  def self.create_from_item(item)
    new(item.category_id, item.category_name, item.resource_name, [item])
  end

  def initialize(id, name, resource, items = [])
    @id        = id
    @name      = name
    @resource  = resource
    @items     = items
    @link_path = nil
  end

  def push(item)
    if item.category_id == id
      @items << item
    else
      raise InvalidCategoryID
    end
  end

  def access?(item)
    (id == item.category_id) && ( resource == item.resource_name )
  end

  def link_path(team)
    if @link_path.nil?
      @link_path = case resource
      when 'team'
        URL_HELPER.team_path(team.id)
      when 'project'
        URL_HELPER.team_project_path(team.id, id)
      else
        raise "非法的资源: #{resource}"
      end
    end

    @link_path
  end

  def to_hash_data
    {
      id: id,
      name: name,
      resource: resource,
      items_count: items.count,
      items: items.map(&:to_hash_data)
    }
  end

end
