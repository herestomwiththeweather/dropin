require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "When matching events by category" do
    before do
      @players_description = "Drop-ins Summer Player 15 & up"
      @players2_description = "Drop-ins Summer 15 & up"
      @players3_description = "December Drop-in"
      @players4_description = "Spring Break Stick & Pucks All Ages "
      @goalies_description = "Drop-ins Summer Goalie 15 & up"
      @freestyle_description = "Freestyle"
      @takedown_description = "Takedown - Drop-in Summer Goalie"
      @blah_description = "blahblahblah"
    end

    it "should match players" do
      expect(Event::category_match?(@players_description, Event::PLAYERS)).to be_truthy
    end

    it "should match abbreviated players" do
      expect(Event::category_match?(@players2_description, Event::PLAYERS)).to be_truthy
    end

    it "should match abbreviated players that does not begin with Drop" do
      expect(Event::category_match?(@players3_description, Event::PLAYERS)).to be_truthy
    end

    it "should match Stick & Puck for player" do
      expect(Event::category_match?(@players4_description, Event::PLAYERS)).to be_truthy
    end

    it "should match goalies" do
      expect(Event::category_match?(@goalies_description, Event::GOALIES)).to be_truthy
    end

    it "should not match abbreviated players" do
      expect(Event::category_match?(@players2_description, Event::GOALIES)).to be_falsey
    end

    it "should match freestyle" do
      expect(Event::category_match?(@freestyle_description, Event::FREESTYLE)).to be_truthy
    end

    it "should not match takedown" do
      expect(Event::category_match?(@takedown_description, Event::GOALIES)).to be_falsey
    end

    it "should not match blahblahblah" do
      expect(Event::category_match?(@blah_description, Event::GOALIES)).to be_falsey
    end
  end
end
