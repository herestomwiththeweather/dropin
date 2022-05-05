class EventsController < ApplicationController
  def index
    @events = Event.monthly_events(params.fetch(:start_date, Date.today).to_date, params[:category])
  end

  def show
    @event = Event.find(params[:id])
  end
end
