require "rails_helper"

RSpec.describe IngredientFetcherService do
  describe ".fetch" do
    let(:api_response) do
      {
        "meals" => [
          { "strIngredient" => "Cheese" },
          { "strIngredient" => "Eggs" },
          { "strIngredient" => "cheese" }
        ]
      }
    end

    before do
      allow(HTTParty).to receive(:get).and_return(
        double(success?: true, parsed_response: api_response)
      )
    end

    it "returns a sorted, downcased, unique list of ingredients" do
      result = described_class.fetch
      expect(result).to eq([ "cheese", "eggs" ])
    end

    it "uses Rails.cache" do
      expect(Rails.cache).to receive(:fetch).with("mealdb:ingredients:list", expires_in: 24.hours)
      described_class.fetch
    end
  end
end
