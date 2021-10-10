class CreateIntegrations < ActiveRecord::Migration[5.2]
  def change
    create_table :integrations do |t|
      t.string :subdomain
      t.string :password
      t.string :insalesid
      t.references :user, foreign_key: true
      t.string :inskey
      t.string :status

      t.timestamps
    end
  end
end
