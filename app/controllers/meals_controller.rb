class MealsController < ApplicationController
  before_action :require_login

  def index
    @meals = current_user.meals.includes(:ingredients).order(created_at: :desc)
  end

  def show
    @meal = current_user.meals.includes(:ingredients).find(params[:id])
  end
end
