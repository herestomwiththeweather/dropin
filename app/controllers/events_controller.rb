class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:add]

  def index
    if params[:id].present?
      client = Client.where(company: params[:id]).first
    else
      client = Client.find(Event::DEFAULT_CLIENT_ID)
    end
    @events = Event.monthly_events(client, params.fetch(:start_date, Date.today).to_date, params[:category])
  end

  def add
    @json = JSON.parse(request.body.string)
    Rails.logger.info "company: #{@json['company']}"
    Rails.logger.info "date: #{@json['date']}"

    events_added = Event::add_dropin(@json['date'], @json['company'])
    message = events_added.nil? ? "error" : "#{events_added} events found"

    respond_to do |format|
      format.html { render plain: message, status: 200 }
    end
  end

  def upcoming
    @client = Client.find(Event::DEFAULT_CLIENT_ID)
    if params[:event_identifier].present?
      # should be same as upcoming_event() because browser received it from actioncable which used upcoming_event()
      event_id = params[:event_identifier]
      Rails.logger.info "events#upcoming() received event id: #{event_id}"
    end
    @event, @next_event = Event::upcoming_events
    @event.refresh_people
    @next_event.refresh_people
  end

  def bfree
    @client = Client.find(Event::SECOND_CLIENT_ID)
    if params[:event_identifier].present?
      # should be same as upcoming_event() because browser received it from actioncable which used upcoming_event()
      event_id = params[:event_identifier]
      Rails.logger.info "events#bfree() received event id: #{event_id}"
    end
    @event, @next_event = Event::bfree_events
    @event.refresh_people
    @next_event.refresh_people
  end

  def show
    @event = Event.find(params[:id])
  end
end
