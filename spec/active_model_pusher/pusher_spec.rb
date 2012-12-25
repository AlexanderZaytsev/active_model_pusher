require 'spec_helper'

describe ActiveModel::Pusher do

  describe '#parse_push_params' do
    before do
      @pusher = AlienPusher.new(Class.new)
      @event = :created
      @socket_id = 1234
    end

    it { @pusher.send(:parse_push_params, @event).should eq([@event, nil]) }
    it { @pusher.send(:parse_push_params, @event, @socket_id).should eq([@event, @socket_id]) }
    it { @pusher.send(:parse_push_params, @socket_id).should eq([nil, @socket_id]) }
  end

  describe '#push!' do
    it 'can be called with the event and socket_id' do
      alien = Alien.new
      pusher = AlienPusher.new(alien)
      socket_id = 1234
      Pusher.should_receive(:trigger).with('aliens', 'created', alien.as_json, socket_id)

      pusher.push!(:created, socket_id)
    end

    it 'can be called without the event' do
      alien = CreatedAlien.new
      pusher = AlienPusher.new(alien)

      Pusher.should_receive(:trigger).with('created-aliens', 'created', alien.as_json, nil)

      pusher.push!
    end

    it 'can be called with socket_id only' do
      alien = CreatedAlien.new
      pusher = AlienPusher.new(alien)
      socket_id = 1234

      Pusher.should_receive(:trigger).with('created-aliens', 'created', alien.as_json, socket_id)

      pusher.push! socket_id
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

      Pusher.should_receive(:trigger).with('custom-channel', 'custom-created', alien.as_json, nil)

      pusher.push! :created
    end
  end
end