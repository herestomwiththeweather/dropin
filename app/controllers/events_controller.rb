class EventsController < ApplicationController
  def index
    if params[:id].present?
      client = Client.where(company: params[:id]).first
    else
      client = Client.find(Event::DEFAULT_CLIENT_ID)
    end
    @events = Event.monthly_events(client, params.fetch(:start_date, Date.today).to_date, params[:category])
  end

  def upcoming
    if params[:event_identifier].present?
      # should be same as upcoming_event() because browser received it from actioncable which used upcoming_event()
      event_id = params[:event_identifier]
      Rails.logger.info "events#upcoming() received event id: #{event_id}"
    end
    @event, @next_event = Event::upcoming_events
  end

  def show
    @event = Event.find(params[:id])
  end
end
