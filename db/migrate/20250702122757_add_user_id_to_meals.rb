class AddUserIdToMeals < ActiveRecord::Migration[8.0]
  def change
    add_reference :meals, :user, null: true, foreign_key: true
  end
end
