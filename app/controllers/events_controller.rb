class EventsController < ApplicationController
  def index
    start_date = params.fetch(:start_date, Date.today).to_date
    @events = Event.where(start_at: start_date.beginning_of_month..start_date.end_of_month)
  end

  def show
    @event = Event.find(params[:id])
  end
end
