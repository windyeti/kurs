class AddForToPayplan < ActiveRecord::Migration[5.2]
  def change
    add_column :payplans, :for, :string
  end
end
