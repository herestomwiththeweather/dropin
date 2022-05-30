require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "When matching events by category" do
    before do
      @players_description = "Drop-ins Summer Player 15 & up"
      @goalies_description = "Drop-ins Summer Goalie 15 & up"
      @freestyle_description = "Freestyle"
    end

    it "should match players" do
      expect(Event::category_match?(@players_description, Event::PLAYERS)).to be_truthy
    end

    it "should match goalies" do
      expect(Event::category_match?(@goalies_description, Event::GOALIES)).to be_truthy
    end

    it "should match freestyle" do
      expect(Event::category_match?(@freestyle_description, Event::FREESTYLE)).to be_truthy
    end
  end
end
