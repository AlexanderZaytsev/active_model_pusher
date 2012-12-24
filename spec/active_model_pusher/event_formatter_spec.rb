require 'spec_helper'

describe ActiveModel::Pusher::EventFormatter do
  before do
    @formatter = ActiveModel::Pusher::EventFormatter
  end

  it 'uses records class name and event name by default' do
    record = Alien.new
    @formatter.new(record, :created).event.should == 'alien-created'
  end

  it 'dasherizes record' do
    record = ActiveModelAlien.new
    @formatter.new(record, :updated).event.should == 'active-model-alien-updated'
  end

  it 'dasherizes event' do
    record = Alien.new
    @formatter.new(record, :status_updated).event.should == 'alien-status-updated'
  end

end