class MealdbController < ApplicationController
  before_action :require_login

  def suggest
    @available_ingredients = IngredientFetcherService.fetch

    ingredients = params[:ingredients] || []

    if ingredients.any?
      service = MealdbSearchService.new(ingredients)
      @matched_ids = service.search_and_intersect_ids

      @meal_data = service.full_meal_data(@matched_ids.sample) if @matched_ids.any?
      flash.now[:alert] = "No meals found" if @matched_ids.empty?
    end
  end

  def save
    mealdb_data = MealdbSearchService.new.full_meal_data(params[:id])

    return redirect_to mealdb_suggest_path, notice: "Meal not found" unless mealdb_data.present?

    existing_meal = Meal.find_by(external_id: mealdb_data["idMeal"])

    return redirect_to meal_path(existing_meal), notice: "Meal already exists" if existing_meal.present?

    meal = Meal.create_with_ingredients(mealdb_data)

    redirect_to meal_path(meal), notice: "Meal saved"
  end
end
