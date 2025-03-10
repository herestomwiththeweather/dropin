require 'rails_helper'

RSpec.describe Person, :type => :model do
  describe "when creating a new person" do
    before do
      @client = Client.create(company: 'Boston Garden')
      @person = Person.new(name: 'Bobby Orr', identifier: 12345, client: @client)
    end

    it "should be valid" do
      expect(@person).to be_valid
    end

    it "should have a valid short name" do
      expect(@person.short_name).to eq('Bobby O.')
    end
  end
end
