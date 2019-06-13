module Utility

  # date_range_floor = Utility::DateRange.new(start_date: 1.day.ago, end_date: nil)
  # date_range_ceiling = Utility::DateRange.new(end_date: 1.day.after, start_date: nil)
  # date_range = Utility::DateRange.new(start_date: 7.days.before, end_date: 7.days.after)
  # date_range_with_defaults = Utility::DateRange.new(start_date: 7.days.before)
  # date_range_with_defaults = Utility::DateRange.new(end_date: 7.days.before)
  class DateRange
    attr_reader :start_date, :end_date
    def initialize(args)
      args = defaults.merge(args)

      @start_date = args[:start_date]
      @end_date = args[:end_date]
      @start_date, @end_date = @end_date, @start_date if @start_date && @end_date && @end_date < @start_date
    end

    def has_start?
      date_is_present?(@start_date)
    end

    def has_end?
      date_is_present?(@end_date)
    end

    private

      def date_is_present?(date)
        !date.nil?
      end

      def defaults
        { start_date: default_start, end_date: default_end }
      end

      def default_start
        1.months.ago
      end

      def default_end
        0.months.ago
      end
  end
end
