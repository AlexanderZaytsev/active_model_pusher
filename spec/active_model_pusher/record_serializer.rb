require 'spec_helper'

describe ActiveModel::Pusher::RecordSerializer do
  before do
    @serializer = ActiveModel::Pusher::RecordSerializer
  end

  it 'serializes record with active_model_serializers gem' do
    record = ActiveModelAlienWithSerializer.new

    @serializer.new(record).serialize!.should eq({ id: 2 })
  end

  it 'serializes record by calling as_json on it' do
    record = Alien.new

    @serializer.new(record).serialize!.should eq({ id: 1 })
  end

  it 'prefers active_model_serializer to as_json' do
    record = Class.new(ActiveModelAlienWithSerializer) do
      def as_json
        { id: 1 }
      end
    end.new

    @serializer.new(record).serialize!.should eq({ id: 2 })
  end

  it 'raises an exception when record cannot be serialized' do
    expect { @serializer.new(Class.new).serialize! }.to raise_error(ActiveModel::Pusher::RecordSerializer::RecordCannotBeSerializedError)
  end


end