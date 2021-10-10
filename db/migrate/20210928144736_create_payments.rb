class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :user, foreign_key: true
      t.references :invoice, foreign_key: true
      t.references :payplan, foreign_key: true
      t.string :status, default: "Не оплачен"
      t.string :paymenttype
      t.string :paymentdate
      t.string :paymentid
      t.string :subdomain
      t.belongs_to :paymentable, polymorphic: true

      t.timestamps
    end
  end
end
