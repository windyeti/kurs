class CreateReviewIntegrations < ActiveRecord::Migration[5.2]
  def change
    create_table :review_integrations do |t|
      t.references :user, foreign_key: true
      t.references :integration, foreign_key: true
      t.string :subdomain
      t.string :insalesid
      t.boolean :status, default: false
      t.boolean :ready, default: false

      t.timestamps
    end
  end
end
