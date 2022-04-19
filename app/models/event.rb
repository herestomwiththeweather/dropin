class Event < ApplicationRecord
  has_many :registrations
  has_many :people, through: :registrations

  PLAYERS = 1
  GOALIES = 2
  CATEGORIES = [PLAYERS, GOALIES]

  CATEGORY_TEXT = {
    PLAYERS => "Drop-in April Player",
    GOALIES => "Drop-in April Goalie"
  }

  CATEGORY_SHORT_TEXT = {
    PLAYERS => "Players",
    GOALIES => "Goalies"
  }

  CACHE_TIME_INTERVAL = 3.minutes

  validates :identifier, presence: true, uniqueness: true
  validates :category, inclusion: {in: CATEGORIES}

  class << self
    def get_events(event_date)
      day_after = (Time.parse(event_date) + 1.day.in_seconds).strftime('%Y-%m-%d')
      client = Client.first
      client.request("events?company=#{client.company}&filter[end__gte]=#{event_date}T00:00:00&filter[start__lt]=#{day_after}T00:00:00")
    end

    def add_dropin(target_date)
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

    def upcoming_event_by_category(event_category)
      # find the earliest start_at after the current time (minus one hour)
      where(category: event_category).where('start_at > ?', 90.minutes.ago).order('start_at ASC').first
    end

    def monthly_events(start_date)
      where(start_at: start_date.beginning_of_month..start_date.end_of_month+1)
    end
  end

  def cached_people
    people.map(&:name)
  end

  def refresh_people
    update_attribute(:last_fetched_at, Time.now)
    client = Client.first
    event_response = client.get_event(identifier)
    event = JSON.parse(event_response.body)
    people_array = nil == event['included'] ? [] : event['included'].map {|person| [person['id'],person['attributes']['full_name']]}
    people_array.each do |p|
      person = Person.find_or_create_by(identifier: p[0], name: p[1])
      registration = Registration.find_or_create_by(person: person, event: self)
    end
    people_array.map {|p| p[1]}
  end

  def refresh_data?
    # Only refresh data if current time is before start time and its been greater than CACHE_TIME_INTERVAL since the last refresh
    (Time.now < start_at) && (Time.now > last_fetched_at + CACHE_TIME_INTERVAL)
  end

  def get_people
    refresh_people if last_fetched_at.nil?
    if refresh_data?
      refresh_people
    else
      cached_people
    end
  end

  def count
    registrations.count
  end
end
