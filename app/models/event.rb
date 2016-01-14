class Event < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :resource, polymorphic: true

end
