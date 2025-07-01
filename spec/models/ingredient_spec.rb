require "rails_helper"

RSpec.describe Ingredient, type: :model do
  describe "associations" do
    it "has many meal_ingredients" do
      is_expected.to have_many(:meal_ingredients).dependent(:destroy)
    end

    it "has many meals through meal_ingredients" do
      is_expected.to have_many(:meals).through(:meal_ingredients)
    end
  end

  describe "validations" do
    it "validates presence of name" do
      is_expected.to validate_presence_of(:name)
    end

    it "validates uniqueness of name (case insensitive)" do
      described_class.create!(name: "Tomato")
      ingredient = described_class.new(name: "tomato")
      expect(ingredient).not_to be_valid
    end
  end
end
