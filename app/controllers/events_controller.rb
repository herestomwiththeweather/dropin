class EventsController < ApplicationController
  def index
    @events = Event.monthly_events(params.fetch(:start_date, Date.today).to_date)
  end

  def show
    @event = Event.find(params[:id])
  end
end
