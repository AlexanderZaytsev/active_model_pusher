module ActiveModel
  class Pusher
    class RecordEventRecognizer
      def initialize(record)
        @record = record
      end

      def event
        return nil unless can_be_recognized?

        if created?
          :created
        elsif updated?
          :updated
        elsif destroyed?
          :destroyed
        else
          nil
        end
      end

    private
      def can_be_recognized?
        @record.respond_to? :previous_changes
      end

      def created?
        @record.previous_changes.include? 'id'
      end

      def updated?
        @record.previous_changes.any?
      end

      def destroyed?
        @record.destroyed?
      end
    end

  end
end