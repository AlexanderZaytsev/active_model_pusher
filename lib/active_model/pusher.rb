module ActiveModel
  class Pusher

    class_attribute :_events
    self._events = nil

    class << self
      def events(*events)
        self._events = events
      end
    end

    def initialize(record)
      @record = record
    end

    def push!(event_or_params = nil, params = {})
      event, params = parse_push_params(event_or_params, params)

      event ||= RecordEventRecognizer.new(record).event

      events.validate! event

      ::Pusher.trigger channel(event), event(event), data, params
    end

    private
      def events
        @events ||= Events.new self._events
      end

      def record
        @record
      end

      def channel(event)
        @channel ||= RecordChannel.new(record, event).channel
      end

      def event(event)
        event.to_s.underscore.dasherize
      end

      def data
        @data ||= RecordSerializer.new(record).serialize!
      end

      def parse_push_params(event_or_params = nil, params = {})
        # Tell me if there is a better way of doing this

        if event_or_params && params
          event = event_or_params
          params = params
        end

        if event_or_params && params.none?
          if events.validate(event_or_params)
            event = event_or_params
            params = {}
          else
            event = nil
            params = event_or_params
          end
        end

        [event, params]
      end


  end
end