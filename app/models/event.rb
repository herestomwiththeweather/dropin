class Event < ApplicationRecord
  has_many :registrations
  has_many :people, through: :registrations
  belongs_to :client

  scope :monthly, -> (start_date) { where(start_at: start_date.beginning_of_month..start_date.end_of_month+1) }
  scope :by_category, -> (category) { where(category: category) }
  scope :by_client_id, -> (client_id) { where(client_id: client_id) }
  scope :exclude_category, -> (category) { where.not(category: category) }

  DEFAULT_CLIENT_ID = 1
  SECOND_CLIENT_ID = 2

  PLAYERS = 1
  GOALIES = 2
  FREESTYLE = 3
  CATEGORIES = [PLAYERS, GOALIES, FREESTYLE]

  CATEGORY_SHORT_TEXT = {
    PLAYERS => "Players",
    GOALIES => "Goalies",
    FREESTYLE => "Freestyle"
  }

  CATEGORY_FULL_NAME = {
    PLAYERS => true,
    GOALIES => true,
    FREESTYLE => false
  }

  CACHE_TIME_INTERVAL = 3.minutes
  MARGIN_INTERVAL = 15.minutes

  validates :identifier, presence: true, uniqueness: { scope: :client_id }
  validates :category, inclusion: {in: CATEGORIES}

  class << self
    def category_match?(description, category)
      description =~ /^(?!Takedown).*$/ && case category
      when PLAYERS
        description =~ /Player/ || ((description =~ /Drop/ || description =~ /Stick & Puck/) && description =~ /^((?!Goalie).)*$/)
      when GOALIES
        description =~ /Goalie/
      when FREESTYLE
        description =~ /Freestyle/
      end
    end

    def add_dropin(target_date, company)
      #target_date = '2022-03-08'

      client = Client.where(company: company).first
      return nil if client.nil?

      resp = client.get_events(target_date)
      events = JSON.parse(resp.body)

      CATEGORIES.each do |category|
        selected_events = events['data'].select {|e| category_match?(e['attributes']['desc'], category)}
        selected_events.each do |event|
          create(
            client_id: client.id,
            identifier: event['id'],
            start_at: event['attributes']['start'].in_time_zone, # start time is not in UTC so use in_time_zone to fix that
            category: category
          )
        end
      end
    end

    def upcoming_event_by_category(event_category)
      # find the earliest start_at after the current time (minus 1.5 hours)
      where(category: event_category).where('start_at > ?', 90.minutes.ago).order('start_at ASC').first
    end

    def upcoming_event
      # find the earliest start_at after the current time (minus 30 minutes)
      where('start_at > ?', 30.minutes.ago).by_client_id(DEFAULT_CLIENT_ID).order('start_at ASC').first
    end

    def upcoming_events
      events = where('start_at > ?', 30.minutes.ago).by_client_id(DEFAULT_CLIENT_ID).where.not(category: GOALIES).order('start_at ASC')
      [events.first, events.second]
    end

    def bfree_events
      events = where('start_at > ?', 30.minutes.ago).by_client_id(SECOND_CLIENT_ID).where(category: FREESTYLE).order('start_at ASC')
      [events.first, events.second]
    end

    def monthly_events(client, start_date, category)
      if 'freestyle' == category
        monthly(start_date).by_client_id(client.id).by_category(FREESTYLE)
      else
        monthly(start_date).by_client_id(client.id).exclude_category(FREESTYLE)
      end
    end
  end

  def sibling
    Event.where(start_at: start_at).where.not(category: category).first
  end

  def board_refresh_data?
    # To keep board data updated, refresh if current time is later than 60 minutes befoe event's starting time
    refresh_data? && Time.now > start_at - 60.minutes
  end

  def board_refresh
    refresh_people if last_fetched_at.nil?
    if board_refresh_data?
      refresh_people
    end
  end

  def cached_people
    CATEGORY_FULL_NAME[self.category] ? people.map(&:name) : people.map(&:short_name)
  end

  def refresh_people
    registration_ids = self.registrations.map(&:id)
    update_attribute(:last_fetched_at, Time.now)
    event_response = client.get_event(identifier)
    event = JSON.parse(event_response.body)
    people_array = nil == event['included'] ? [] : event['included'].map {|person| [person['id'],person['attributes']['full_name']]}
    people_array.each do |p|
      person = Person.find_or_create_by!(identifier: p[0])
      person.update_attribute(:name, p[1]) if p[1] != person.name
      registration = Registration.find_or_create_by(person: person, event: self)
      registration_ids.reject! {|i| registration.id == i}
    end
    registration_ids.each do |registration_id|
      registration_to_delete = Registration.find(registration_id)
      p = registration_to_delete.person
      Rails.logger.info "Deleting registration for #{p.name} (#{p.id}) for event #{self.id}"
      registration_to_delete.destroy
    end
    people_array.map {|p| CATEGORY_FULL_NAME[self.category] ? p[1] : p[1][0..p[1].index(' ')+1].concat('.')}
  end

  def refresh_data?
    # Only refresh data if current time is before start time and its been greater than CACHE_TIME_INTERVAL since the last refresh
    (Time.now < start_at + MARGIN_INTERVAL) && (Time.now > last_fetched_at + CACHE_TIME_INTERVAL)
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
    refresh_people if last_fetched_at.nil?
    refresh_people if refresh_data?
    registrations.count
  end

  def start_time
    start_at.to_s(:rfc822)
  end

  def people_text
    CATEGORY_SHORT_TEXT[category]
  end
end
