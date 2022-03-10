class PlayersController < ApplicationController
  def index
    @players_event = Event.upcoming_event_by_category(Event::PLAYERS)
    @players = @players_event.get_people

    @goalies_event = Event.upcoming_event_by_category(Event::GOALIES)
    @goalies = @goalies_event.get_people
  end
end
