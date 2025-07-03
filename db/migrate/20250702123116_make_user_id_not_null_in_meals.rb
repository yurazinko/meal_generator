class MakeUserIdNotNullInMeals < ActiveRecord::Migration[8.0]
  def change
    change_column_null :meals, :user_id, false
  end
end
