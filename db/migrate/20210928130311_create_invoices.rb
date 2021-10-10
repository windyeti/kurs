class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.references :payplan, foreign_key: true
      t.decimal :sum
      t.string :status, default: "Не оплачен"
      t.string :payertype
      t.string :paymenttype
      t.belongs_to :invoiceable, polymorphic: true

      t.timestamps
    end
  end
end
