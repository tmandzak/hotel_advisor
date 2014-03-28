class AddApprovedToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :approved, :boolean, default: false
  end
end
