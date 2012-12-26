module ActiveModel
  class Pusher
    class RecordSerializer
      class RecordCannotBeSerializedError < StandardError
        attr_reader :record

        def initialize(record)
          @record = record
        end

        def to_s
          "#{@record} cannot be serialized."
        end
      end

      def initialize(record)
        @record = record
      end

      def serialize!
        raise RecordCannotBeSerializedError.new(@record) unless can_be_serialized?

        serializer.as_json
      end

      private
        def serializer
          if @record.respond_to?(:active_model_serializer)
            serializer = @record.active_model_serializer
            serializer.new @record
          elsif @record.respond_to?(:as_json)
            @record
          end
        end

        def can_be_serialized?
          @record.respond_to?(:active_model_serializer) || @record.respond_to?(:as_json)
        end
    end
  end
end