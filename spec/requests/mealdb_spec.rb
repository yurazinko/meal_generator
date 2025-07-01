require 'rails_helper'

RSpec.describe MealdbController, type: :request do
  let(:user) { create(:user) }
  let(:valid_meal_data) do
    {
      "idMeal" => "12345",
      "strMeal" => "Test Meal",
      "strInstructions" => "Cook it well",
      "strMealThumb" => "http://example.com/image.jpg",
      "strIngredient1" => "Eggs",
      "strIngredient2" => "Cheese",
      "strIngredient3" => ""
    }
  end

  before do
    allow_any_instance_of(MealdbController).to receive(:require_login).and_return(true)
  end

  describe "GET #suggest" do
  it "returns success and renders available ingredients" do
    allow(IngredientFetcherService).to receive(:fetch).and_return([ "eggs", "cheese" ])

    get mealdb_suggest_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("eggs")
    expect(response.body).to include("cheese")
  end

  context "when ingredients param present" do
    it "calls MealdbSearchService and assigns matched meals and meal data" do
      service_double = instance_double(MealdbSearchService)
      allow(MealdbSearchService).to receive(:new).with([ "eggs" ]).and_return(service_double)
      allow(service_double).to receive(:search_and_intersect_ids).and_return([ "123" ])
      allow(service_double).to receive(:full_meal_data).with("123").and_return(valid_meal_data)

      get mealdb_suggest_path, params: { ingredients: [ "eggs" ] }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(valid_meal_data["strMeal"])
    end

    it "shows alert if no meals found" do
      service_double = instance_double(MealdbSearchService)
      allow(MealdbSearchService).to receive(:new).and_return(service_double)
      allow(service_double).to receive(:search_and_intersect_ids).and_return([])

      get mealdb_suggest_path, params: { ingredients: [ "unknown" ] }

      expect(response.body).to include("No meals found")
    end
  end
end

  describe "POST #save" do
    context "when meal data not found" do
      it "redirects to suggest with alert" do
        service_double = instance_double(MealdbSearchService)
        allow(MealdbSearchService).to receive(:new).and_return(service_double)
        allow(service_double).to receive(:full_meal_data).with("999").and_return(nil)

        post save_mealdb_meal_path(id: "999")

        expect(response).to redirect_to(mealdb_suggest_path)
        follow_redirect!
        expect(flash[:notice]).to include("Meal not found")
      end
    end

    context "when meal already exists" do
      it "redirects to existing meal" do
        existing_meal = create(:meal, external_id: "12345")

        service_double = instance_double(MealdbSearchService)
        allow(MealdbSearchService).to receive(:new).and_return(service_double)
        allow(service_double).to receive(:full_meal_data).with("12345").and_return(valid_meal_data)

        post save_mealdb_meal_path(id: "12345")

        expect(response).to redirect_to(meal_path(existing_meal))
        follow_redirect!
        expect(flash[:notice]).to include("Meal already exists")
      end
    end

    context "when saving new meal" do
      it "creates meal and ingredients and redirects to meal page" do
        service_double = instance_double(MealdbSearchService)
        allow(MealdbSearchService).to receive(:new).and_return(service_double)
        allow(service_double).to receive(:full_meal_data).with("12345").and_return(valid_meal_data)

        expect {
          post save_mealdb_meal_path(id: "12345")
        }.to change(Meal, :count).by(1)
          .and change(Ingredient, :count).by(2)
          .and change(MealIngredient, :count).by(2)

        meal = Meal.last
        expect(response).to redirect_to(meal_path(meal))
        follow_redirect!
        expect(flash[:notice]).to include("Meal saved")
      end
    end
  end
end
