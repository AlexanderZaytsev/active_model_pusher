module ActiveModel
  class Pusher
    class Events
      class InvalidEventError < StandardError
        attr_reader :event

        def initialize(event)
          @event = event
        end

        def to_s
          "Event `#{event}` is not allowed. Add it into your pusher's `events` class attribute"
        end
      end


      def initialize(*events)
        @events = Array(events).flatten
      end

      def validate(event)
        @events.include?(event)
      end

      def validate!(event)
        if validate(event) == false
          raise InvalidEventError.new(event)
        else
          true
        end
      end
    end
  end
end