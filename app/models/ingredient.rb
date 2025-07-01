class Ingredient < ApplicationRecord
  has_many :meal_ingredients, dependent: :destroy
  has_many :meals, through: :meal_ingredients

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
