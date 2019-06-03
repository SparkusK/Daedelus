module Utility
  class DateRange
    attr_reader :start_date, :end_date
    def initialize(args)
      args = defaults.merge(args)

      start_date = set_default(args[:default_start], args[:start_date], args[:use_defaults])
      end_date = set_default(args[:default_end], args[:end_date], args[:use_defaults])
      if end_date < start_date
        @start_date = end_date
        @end_date = start_date
      else
        @start_date = start_date
        @end_date = end_date
      end
    end

    def has_start?
      date_is_present?(@start_date)
    end

    def has_end?
      date_is_present(@end_date)
    end

    private

      def date_is_present?(date)
        !date.nil? && !date.empty?
      end

      def set_default(value, date, use_defaults)
        ( (date.nil? || date.empty?) && use_defaults) ? value : nil
      end

      def defaults
        {default_start: default_start, default_end: default_end, use_defaults: true}
      end

      def default_start
        1.months.ago
      end

      def default_end
        0.months.ago
      end
  end
end
