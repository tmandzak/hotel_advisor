class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.belongs_to :hotel	
      t.string :country
      t.string :state
      t.string :city
      t.string :street

      t.timestamps
    end
  end
end
