class CreateMeals < ActiveRecord::Migration[8.0]
  def change
    create_table :meals do |t|
      t.string :name, null: false
      t.text :instructions
      t.string :image_url
      t.string :external_id, index: { unique: true }

      t.timestamps
    end
  end
end
