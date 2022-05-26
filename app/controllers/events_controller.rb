class EventsController < ApplicationController
  def index
    @events = Event.monthly_events(params.fetch(:start_date, Date.today).to_date, params[:category])
  end

  def upcoming
    if params[:event_identifier].present?
      # should be same as upcoming_event() because browser received it from actioncable which used upcoming_event()
      event_id = params[:event_identifier]
      Rails.logger.info "events#upcoming() received event id: #{event_id}"
    end
    @event = Event::upcoming_event
    @event2 = nil
    if Event::PLAYERS == @event.category
      @event2 = Event::upcoming_event_by_category(Event::GOALIES)
    end
    if Event::GOALIES == @event.category
      @event2 = Event::upcoming_event_by_category(Event::PLAYERS)
    end
  end

  def show
    @event = Event.find(params[:id])
  end
end
