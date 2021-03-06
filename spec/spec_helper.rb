require 'active_model_pusher'

class Pusher
  def self.trigger(channel, event, json, params = {})
    true
  end
end

class AlienPusher < ActiveModel::Pusher
  events :created
end

class Alien
  def id
    1
  end

  def as_json
    { id: 1 }
  end
end

class ActiveModelAlien < Alien
  def previous_changes
    []
  end
end



class ActiveModelAlienWithSerializer < ActiveModelAlien
  class ActiveModelSerializer
    def initialize(record)
    end
    def as_json
      { id: 2 }
    end
  end

  def active_model_serializer
    ActiveModelSerializer
  end
end


class CreatedAlien < ActiveModelAlien
  def previous_changes
    { 'id' => [nil, 1] }
  end
end

class UpdatedAlien < ActiveModelAlien
  def previous_changes
    { 'planet_id' => [1, 2] }
  end
end

class DestroyedAlien < ActiveModelAlien
  def destroyed?
    true
  end
end
