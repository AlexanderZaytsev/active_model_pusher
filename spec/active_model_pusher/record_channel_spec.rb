require 'spec_helper'

describe ActiveModel::Pusher::RecordChannel do
  describe '#to_s' do
    it 'gets channel from record' do
      record = Class.new do
        def channel
          'alien'
        end
      end.new

      record_channel = ActiveModel::Pusher::RecordChannel.new(record)

      record_channel.channel!.should == 'alien'
    end

    it 'raises exception when record does not have the channel column' do
      record = Class.new
      record_channel = ActiveModel::Pusher::RecordChannel.new(record)

      expect { record_channel.channel! }.to raise_error(ActiveModel::Pusher::RecordChannel::MissingChannelError)
    end
  end
end