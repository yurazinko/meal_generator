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
    service = MealdbSearchService.new([])
    data = service.full_meal_data(params[:id])
    return redirect_to mealdb_suggest_path, notice: "Meal not found" unless data

    existing = Meal.find_by(external_id: data["idMeal"])

    return redirect_to meal_path(existing), notice: "Meal already exists" if existing

    meal = Meal.create!(
      name: data["strMeal"],
      instructions: data["strInstructions"],
      image_url: data["strMealThumb"],
      external_id: data["idMeal"]
    )

    (1..20).each do |i|
      ing_name = data["strIngredient#{i}"]
      next if ing_name.blank?

      ingredient = Ingredient.find_or_create_by!(name: ing_name.strip)
      MealIngredient.create!(meal:, ingredient:)
    end

    redirect_to meal_path(meal), notice: "Meal saved"
  end
end
