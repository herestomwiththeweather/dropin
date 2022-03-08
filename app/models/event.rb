class Event < ApplicationRecord
  PLAYERS = 1
  GOALIES = 2
  CATEGORIES = [PLAYERS, GOALIES]

  CATEGORY_TEXT = {
    PLAYERS => "Drop-in March Player",
    GOALIES => "Drop-in March Goalie"
  }

  validates :identifier, presence: true, uniqueness: true
  validates :category, inclusion: {in: CATEGORIES}

  def self.get_events(event_date)
    day_after = (Time.parse(event_date) + 1.day.in_seconds).strftime('%Y-%m-%d')
    client = Client.first
    client.request("events?company=#{client.company}&filter[end__gte]=#{event_date}T00:00:00&filter[start__lt]=#{day_after}T00:00:00")
  end

  def self.add_dropin(target_date)
    #target_date = '2022-03-08'

    resp = get_events(target_date)
    events = JSON.parse(resp.body)

    CATEGORIES.each do |category|
      selected_events = events['data'].select {|e| e['attributes']['desc'] == CATEGORY_TEXT[category]}
      raise "add_next_dropin #{target_date}" if 1 != selected_events.length 
      event = selected_events.first
      create(
        identifier: event['id'],
        start_at: event['attributes']['start'].in_time_zone, # start time is not in UTC so use in_time_zone to fix that
        category: category
      )
    end
  end

  def self.upcoming_event_id_by_category(event_category)
    # find the earliest start_at after the current time (minus one hour)
    where(category: event_category).where('start_at > ?', 60.minutes.ago).order('start_at ASC').first&.identifier
  end
end
