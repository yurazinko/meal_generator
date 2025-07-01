class CreateMealIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :meal_ingredients do |t|
      t.references :meal, foreign_key: true, null: false
      t.references :ingredient, foreign_key: true, null: false

      t.timestamps
    end
  end
end
