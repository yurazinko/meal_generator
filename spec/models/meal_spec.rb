require 'rails_helper'

RSpec.describe Meal, type: :model do
  describe "associations" do
    it "has many meal_ingredients" do
      is_expected.to have_many(:meal_ingredients).dependent(:destroy)
    end

    it "has many ingredients through meal_ingredients" do
      is_expected.to have_many(:ingredients).through(:meal_ingredients)
    end
  end

  describe "validations" do
    it "validates presence of name" do
      is_expected.to validate_presence_of(:name)
    end
  end

  describe "factory" do
    it "is valid with default attributes" do
      expect(build(:meal)).to be_valid
    end
  end
end
