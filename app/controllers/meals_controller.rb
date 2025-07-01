class MealsController < ApplicationController
  before_action :require_login

  def index
    @meals = Meal.includes(:ingredients).order(created_at: :desc)
  end

  def show
    @meal = Meal.includes(:ingredients).find(params[:id])
  end
end
