module Freemium
  class << self
    attr_reader :activity_log

    def with_activity_logging
      @activity_log = ActivityLog.new
      yield
      @activity_log = nil
    end

    def log?
      admin_report_recipients and @activity_log
    end
  end

  class ActivityLog
    include Enumerable
    def events_by_subscription
      @events_by_subscription ||= {}
    end

    def [](subscription)
      events_by_subscription[subscription] ||= []
    end

    def each
      events_by_subscription.each{|subscription, events| yield subscription, events}
    end
  end
end