module ActiveModel
  class Pusher
    class EventFormatter
      def initialize(record, event)
        @record = record
        @event = event
      end

      def event
        [@record.class.name, @event]
          .map(&:to_s)
          .map(&:underscore)
          .map(&:dasherize)
          .join('-')
          .downcase
      end
    end
  end
end