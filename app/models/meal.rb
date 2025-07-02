class Meal < ApplicationRecord
  MEALDB_API_INGREDIENTS_COUNT = 20

  has_many :meal_ingredients, dependent: :destroy
  has_many :ingredients, through: :meal_ingredients

  validates :name, presence: true

  def self.create_with_ingredients(mealdb_data)
    ActiveRecord::Base.transaction do
      meal = create!(
        name: mealdb_data["strMeal"],
        instructions: mealdb_data["strInstructions"],
        image_url: mealdb_data["strMealThumb"],
        external_id: mealdb_data["idMeal"]
      )

      (1..MEALDB_API_INGREDIENTS_COUNT).each do |i|
        ing_name = mealdb_data["strIngredient#{i}"]
        next if ing_name.blank?

        ingredient = Ingredient.find_or_create_by!(name: ing_name.strip)
        MealIngredient.create!(meal:, ingredient:)
      end

      meal
    end
  end
end
