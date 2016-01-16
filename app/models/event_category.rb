class EventCategory

  InvalidCategoryID = Class.new(StandardError)
  URL_HELPER = Rails.application.routes.url_helpers
  
  attr_reader :id
  attr_reader :name
  attr_reader :resouce
  attr_reader :items

  def self.create_from_item(item)
    new(item.category_id, item.category_name, item.resource_name, [item])
  end

  def initialize(id, name, resouce, items = [])
    @id      = id
    @name    = name
    @resouce = resouce
    @items   = items
  end

  def push(item)
    if item.category_id == id
      @items << item
    else
      raise InvalidCategoryID
    end
  end

  def access?(item)
    id == item.category_id ? true : false
  end

  def last_created_at
    @items.sort_by(&:created_at).first.try(:created_at)
  end

  def more_last_than?(item)
    if last_created_at.nil?
      false
    else
      last_created_at > item.create_at ? true : false
    end
  end

  def link_path(team)
    if @link_path.nil?
      path = "team_#{resouce}_path"
      @link_path = URL_HELPER.send(path, team.id, id)
    end

    @link_path
  end
  
end
