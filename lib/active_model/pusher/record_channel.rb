module ActiveModel
  class Pusher
    class RecordChannel
      CHANNEL_COLUMN = :channel

      def initialize(record, event)
        @record = record
        @event = event
      end

      def channel
        from_record_channel_column || from_record_class_name
      end

      private
        def from_record_channel_column
          @record.send(CHANNEL_COLUMN) if @record.respond_to?(CHANNEL_COLUMN)
        end

        def from_record_class_name
          if @event == :created
            @record.class.name.pluralize.underscore.dasherize
          else
            [@record.class.name.pluralize.underscore.dasherize, @record.id].join('-')
          end
        end

    end
  end
end
