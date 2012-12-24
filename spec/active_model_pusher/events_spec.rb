require 'spec_helper'

describe ActiveModel::Pusher::Events do

  it 'accepts individual events' do
    events = ActiveModel::Pusher::Events.new :created

    events.validate!(:created).should be_true
  end

  it 'accepts array' do
    events = ActiveModel::Pusher::Events.new [:created, :updated]

    events.validate!(:updated).should be_true
  end

  it 'accepts indefinite params' do
    events = ActiveModel::Pusher::Events.new :created, :updated

    events.validate!(:updated).should be_true
  end


  describe '#validate!' do
    it 'returns true if event is valid' do
      ActiveModel::Pusher::Events.new([:created, :updated]).validate!(:created).should be_true
    end

    it 'raises an exception if event is invalid' do
      events = ActiveModel::Pusher::Events.new(:created)
      expect { events.validate!(:updated) }.to raise_error(ActiveModel::Pusher::Events::InvalidEventError)
    end
  end
end