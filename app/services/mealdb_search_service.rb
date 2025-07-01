require "httparty"

class MealdbSearchService
  include HTTParty
  base_uri "https://www.themealdb.com/api/json/v1/1"

  def initialize(ingredients = [])
    @ingredients = ingredients.map { |i| i.strip.downcase }.uniq
  end

  def search_and_intersect_ids
    return [] if @ingredients.empty?

    sets = @ingredients.map do |name|
      Rails.cache.fetch("mealdb:filter:#{name.downcase}", expires_in: 12.hours) do
        response = self.class.get("/filter.php?i=#{URI.encode_www_form_component(name)}")

        unless response.success?
          Rails.logger.warn("[MealdbSearchService] Filter API failed for '#{name}'")
          next []
        end

        response.parsed_response.dig("meals")&.map { |meal| meal["idMeal"] } || []
      end
    end

    sets.reduce(&:&) || []
  end

  def full_meal_data(meal_id)
    Rails.cache.fetch("mealdb:meal:#{meal_id}", expires_in: 24.hours) do
      response = self.class.get("/lookup.php?i=#{meal_id}")
      response.success? ? response.parsed_response.dig("meals", 0) : nil
    end
  end
end
