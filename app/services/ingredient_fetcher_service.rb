require "httparty"

class IngredientFetcherService
  API_URL = "https://www.themealdb.com/api/json/v1/1/list.php?i=list"
  CACHE_KEY = "mealdb:ingredients:list"

  def self.fetch
    Rails.cache.fetch(CACHE_KEY, expires_in: 24.hours) do
      response = HTTParty.get(API_URL)

      unless response.success?
        Rails.logger.warn("[IngredientFetcherService] API call failed: #{response.code}")
        return []
      end

      (response.parsed_response["meals"] || [])
        .map { |i| i["strIngredient"].to_s.strip.downcase }
        .uniq
        .sort
    end
  end
end
