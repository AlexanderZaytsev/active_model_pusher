require 'active_model_pusher'

class Pusher
  def self.trigger(channel, event, json, socket_id = nil)
    true
  end
end

class AlienPusher < ActiveModel::Pusher
  events :created
end

class Alien
  def channel
    'alien-channel'
  end

  def as_json
    { id: 1 }
  end
end

class ActiveModelAlien < Alien
  def as_json
    { id: 1 }
  end

  def previous_changes
    []
  end
end



class ActiveModelAlienWithSerializer < ActiveModelAlien
  class ActiveModelSerializer
    def as_json
      { id: 2 }
    end
  end

  def active_model_serializer
    ActiveModelSerializer.new
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
