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

    def push!(event_or_socket_id = nil, socket_id = nil)
      event, socket_id = parse_push_params(event_or_socket_id, socket_id)

      event ||= RecordEventRecognizer.new(record).event

      events.validate! event

      ::Pusher.trigger channel(event), event(event), data, { socket_id: socket_id }
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
        @json ||= RecordSerializer.new(record).json!
      end

      def parse_push_params(event_or_socket_id = nil, socket_id = nil)
        # Tell me if there is a better way of doing this

        if event_or_socket_id && socket_id
          event = event_or_socket_id
        end

        if event_or_socket_id && socket_id.nil?
          if events.validate(event_or_socket_id)
            event = event_or_socket_id
          else
            socket_id = event_or_socket_id
          end
        end

        [event, socket_id]
      end


  end
end