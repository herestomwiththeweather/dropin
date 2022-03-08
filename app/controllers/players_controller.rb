class PlayersController < ApplicationController
  def index
    c = Client.first
    @players = c.get_players
    @goalies = c.get_goalies
  end
end
