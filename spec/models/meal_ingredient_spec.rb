require 'rails_helper'

RSpec.describe MealIngredient, type: :model do
  describe "associations" do
    it "belongs to meal" do
      is_expected.to belong_to(:meal)
    end

    it "belongs to ingredient" do
      is_expected.to belong_to(:ingredient)
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      meal = create(:meal)
      ingredient = create(:ingredient)
      mi = described_class.new(meal:, ingredient:)

      expect(mi).to be_valid
    end

    it "is invalid without a meal" do
      ingredient = create(:ingredient)
      mi = described_class.new(ingredient:)

      expect(mi).not_to be_valid
    end

    it "is invalid without an ingredient" do
      meal = create(:meal)
      mi = described_class.new(meal:)

      expect(mi).not_to be_valid
    end
  end
end
