class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.belongs_to :user
      t.belongs_to :hotel
      t.integer :rate
      t.text :comment
      #t.integer :user_id
      #t.integer :hotel_id

      t.timestamps
    end

    add_index :rates, [:created_at, :rate] 
  end
end
