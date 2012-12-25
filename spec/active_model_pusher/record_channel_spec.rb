require 'spec_helper'

describe ActiveModel::Pusher::RecordChannel do
  describe '#channel' do
    it "gets channel from record's channel column" do

      record = Class.new do
        def channel
          'custom-channel'
        end
      end.new

      record_channel = ActiveModel::Pusher::RecordChannel.new(record, nil)
      record_channel.channel.should == 'custom-channel'
    end

    it 'defaults to class name and record id if the record has no channel column' do
      record = Alien.new
      record_channel = ActiveModel::Pusher::RecordChannel.new(record, :updated)
      record_channel.channel.should == 'aliens-1'
    end

    it 'defaults to pluralized class name if the record was just created and has no channel column' do
      record = Alien.new
      record_channel = ActiveModel::Pusher::RecordChannel.new(record, :created)

      record_channel.channel.should == 'aliens'
    end
  end
end