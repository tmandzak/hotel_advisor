class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.belongs_to :user
      t.string :title
      t.integer :stars
      t.boolean :breakfast
      t.text :description
      t.string :photo
      t.decimal :price
      t.integer :rates_count, default: 0
      t.integer :rates_total, default: 0
      t.decimal :rate_avg, default: 0.0

      t.timestamps
    end

    add_index :hotels, :title, unique: true
    add_index :hotels, [:rate_avg, :rates_count]
  end
end
