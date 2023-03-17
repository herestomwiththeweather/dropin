require 'rails_helper'

RSpec.describe Event, type: :model do

  let(:client) { create :client }
  let(:other_client) { create :client }

  describe "When creating an event" do
    before do
      other_event = create :event, client_id: other_client.id, identifier: '12345'
    end

    it "should allow the same identifier to be used by two events from different clients" do
      event = Event.new(client_id: client.id, identifier: '12345', category: Event::PLAYERS)
      expect(event).to be_valid
    end

    it "should not allow the same identifier to be used by two events from the same client" do
      event = Event.new(client_id: other_client.id, identifier: '12345', category: Event::PLAYERS)
      expect(event.errors[:identifier]).to include("has already been taken")
    end
  end

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
