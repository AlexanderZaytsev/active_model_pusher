require 'spec_helper'

describe ActiveModel::Pusher::RecordEventRecognizer do
  before do
    @recognizer = ActiveModel::Pusher::RecordEventRecognizer
  end

  it 'recognizes :created event' do
    @recognizer.new(CreatedAlien.new).event.should == :created
  end

  it 'recognizes :updated event' do
    @recognizer.new(UpdatedAlien.new).event.should == :updated
  end

  it 'recognizes :destroyed event' do
    @recognizer.new(DestroyedAlien.new).event.should == :destroyed
  end

  it 'returns nil when event cannot be recognized' do
    @recognizer.new(Class.new).event.should be_nil
  end
end