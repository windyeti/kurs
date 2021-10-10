class CreatePayplans < ActiveRecord::Migration[5.2]
  def change
    create_table :payplans do |t|
      t.string :period
      t.decimal :price

      t.timestamps
    end
  end
end
