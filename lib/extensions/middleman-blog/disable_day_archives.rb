require "middleman-blog/calendar_pages"

module DisableDayArchives
  def initialize(*)
    super
    @day_template = nil
  end
end

Middleman::Blog::CalendarPages.prepend DisableDayArchives
