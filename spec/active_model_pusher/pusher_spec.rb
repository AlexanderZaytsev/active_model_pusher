require 'spec_helper'

describe ActiveModel::Pusher do


  describe '#parse_push_params' do
    before do
      @pusher = AlienPusher.new(Class.new)
      @event = :created
      @params = { socket_id: 1234 }
    end

    it { @pusher.send(:parse_push_params, @event).should eq([@event, {}]) }
    it { @pusher.send(:parse_push_params, @event, @params).should eq([@event, @params]) }
    it { @pusher.send(:parse_push_params, @params).should eq([nil, @params]) }
  end

  describe '#push!' do
    it 'can be called with the event and params' do
      alien = Alien.new
      pusher = AlienPusher.new(alien)
      params = { socket_id: 1234 }
      Pusher.should_receive(:trigger).with('aliens', 'created', alien.as_json, params)

      pusher.push!(:created, params)
    end

    it 'can be called without the event' do
      alien = CreatedAlien.new
      pusher = AlienPusher.new(alien)

      Pusher.should_receive(:trigger).with('created-aliens', 'created', alien.as_json, {})

      pusher.push!
    end

    it 'can be called with params only' do
      alien = CreatedAlien.new
      pusher = AlienPusher.new(alien)
      params = { socket_id: 1234 }

      Pusher.should_receive(:trigger).with('created-aliens', 'created', alien.as_json, params)

      pusher.push! params
    end

    it 'allows overriding the `event` and `channel` method' do
      alien = Alien.new
      pusher = Class.new(AlienPusher) do
        def event(event)
          "custom-#{event}"
        end

        def channel(event)
          "custom-channel"
        end
      end.new(alien)

      Pusher.should_receive(:trigger).with('custom-channel', 'custom-created', alien.as_json, {})

      pusher.push! :created
    end
  end
end