module ActiveModel
  class Pusher
    class Events
      class InvalidEventError < StandardError
        attr_reader :event

        def initialize(event)
          @event = event
        end

        def to_s
          "Event `#{@event}` is not allowed. Add it into your pusher's `events` class attribute"
        end
      end


      def initialize(*events)
        @events = Array(events).flatten
      end

      def validate(event)
        # Allow strings and symbols only
        # Return true if there are no whitelisted events

        return false unless event.respond_to? :to_sym

        return true unless @events.any?

        @events.include?(event)
      end

      def any?
        @events.any?
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