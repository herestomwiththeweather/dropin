class PlayersController < ApplicationController
  protect_from_forgery except: :today_count

  def index
    @players_event = Event.upcoming_event_by_category(Event::PLAYERS)
    @goalies_event = Event.upcoming_event_by_category(Event::GOALIES)
  end

  def today_count
    @host = request.host
  end

  def player_count
    @event = Event.upcoming_event_by_category(Event::PLAYERS)
  end

  def goalie_count
    @event = Event.upcoming_event_by_category(Event::GOALIES)
  end
end
