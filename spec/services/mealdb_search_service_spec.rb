require "rails_helper"

RSpec.describe MealdbSearchService do
  describe "#search_and_intersect_ids" do
    let(:ingredients) { [ "eggs", "cheese" ] }

    let(:api_response_eggs) do
      {
        "meals" => [
          { "idMeal" => "1" },
          { "idMeal" => "2" }
        ]
      }
    end

    let(:api_response_cheese) do
      {
        "meals" => [
          { "idMeal" => "2" },
          { "idMeal" => "3" }
        ]
      }
    end

    before do
      Rails.cache.clear

      allow(described_class).to receive(:get).with("/filter.php?i=eggs")
        .and_return(double(success?: true, parsed_response: api_response_eggs))

      allow(described_class).to receive(:get).with("/filter.php?i=cheese")
        .and_return(double(success?: true, parsed_response: api_response_cheese))
    end

    it "returns the intersection of meal IDs from all ingredients" do
      service = described_class.new(ingredients)
      expect(service.search_and_intersect_ids).to eq([ "2" ])
    end
  end

  describe "#full_meal_data" do
    it "returns full meal data" do
      meal_id = "123"
      api_response = { "meals" => [ { "idMeal" => meal_id, "strMeal" => "Pizza" } ] }

      allow(described_class).to receive(:get).with(/lookup\.php\?i=#{meal_id}/).and_return(
        double(success?: true, parsed_response: api_response)
      )

      service = described_class.new
      result = service.full_meal_data(meal_id)

      expect(result["strMeal"]).to eq("Pizza")
    end
  end
end
