class IntegrationChangeStatus < ActiveRecord::Migration[5.2]
  def change
    change_column(:integrations, :status, :boolean, default: false, using: 'status::boolean' )
  end
end
