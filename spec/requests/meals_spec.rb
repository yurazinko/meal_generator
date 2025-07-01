require "rails_helper"

RSpec.describe "MealsController", type: :request do
  let(:user) { create(:user) }

  describe "GET /meals" do
    context "when not logged in" do
      it "redirects to login page" do
        get meals_path
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before { sign_in_as(user) }

      it "returns success" do
        get meals_path
        expect(response).to have_http_status(:ok)
      end

      it "renders meals with ingredients" do
        meal = create(:meal)
        ingredient = create(:ingredient)
        meal.ingredients << ingredient

        get meals_path
        expect(response.body).to include(meal.name)
        expect(response.body).to include(ingredient.name)
      end
    end
  end

  describe "GET /meals/:id" do
    let(:meal) { create(:meal) }

    context "when not logged in" do
      it "redirects to login page" do
        get meal_path(meal)
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in" do
      before { sign_in_as(user) }

      it "returns success" do
        get meal_path(meal)
        expect(response).to have_http_status(:ok)
      end

      it "shows the meal details" do
        ingredient = create(:ingredient)
        meal.ingredients << ingredient

        get meal_path(meal)
        expect(response.body).to include(meal.name)
        expect(response.body).to include(ingredient.name)
      end
    end
  end
end
