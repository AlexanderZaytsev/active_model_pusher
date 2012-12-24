module ActiveModel
  class Pusher
    class RecordChannel

      class MissingChannelError < StandardError
        attr_reader :record, :method

        def initialize(record, method)
          @record = record
          @method = method
        end

        def to_s
          "#{record} does not respond to `#{method}`"
        end
      end

      CHANNEL_COLUMN = :channel

      def initialize(record)
        @record = record
      end

      def channel!
        if @record.respond_to? CHANNEL_COLUMN
          @record.send CHANNEL_COLUMN
        else
          raise MissingChannelError.new(@record, CHANNEL_COLUMN)
        end
      end

    end
  end
end
