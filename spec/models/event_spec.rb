require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "When matching events by category" do
    before do
      @players_description = "Drop-ins Summer Player 15 & up"
      @goalies_description = "Drop-ins Summer Goalie 15 & up"
      @freestyle_description = "Freestyle"
      @takedown_description = "Takedown - Drop-in Summer Goalie"
      @blah_description = "blahblahblah"
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

    it "should not match takedown" do
      expect(Event::category_match?(@takedown_description, Event::GOALIES)).to be_falsey
    end

    it "should not match blahblahblah" do
      expect(Event::category_match?(@blah_description, Event::GOALIES)).to be_falsey
    end
  end
end
