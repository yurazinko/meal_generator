require "httparty"

class MealdbSearchService
  include HTTParty
  base_uri "https://www.themealdb.com/api/json/v1/1"

  def initialize(ingredients = [])
    @ingredients = ingredients.map { |i| i.strip.downcase }.uniq
  end

  def search_and_intersect_ids
    return [] if @ingredients.empty?

    id_sets = @ingredients.map { |ingredient| fetch_meal_ids_for(ingredient) }
    intersect_ids(id_sets)
  end

  def full_meal_data(meal_id)
    Rails.cache.fetch("mealdb:meal:#{meal_id}", expires_in: 24.hours) do
      response = self.class.get("/lookup.php?i=#{meal_id}")
      response.success? ? response.parsed_response.dig("meals", 0) : nil
    end
  end

  private

  def fetch_meal_ids_for(ingredient)
    Rails.cache.fetch("mealdb:filter:#{ingredient.downcase}", expires_in: 12.hours) do
      fetch_ids_from_api(ingredient)
    end
  end

  def fetch_ids_from_api(ingredient)
    response = self.class.get("/filter.php?i=#{URI.encode_www_form_component(ingredient)}")

    unless response.success?
      Rails.logger.warn("[MealdbSearchService] Filter API failed for '#{ingredient}'")
      return []
    end

    response.parsed_response.dig("meals")&.map { |meal| meal["idMeal"] } || []
  end

  def intersect_ids(sets)
    sets.reduce(&:&) || []
  end
end
