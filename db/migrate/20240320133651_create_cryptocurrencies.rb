class CreateCryptocurrencies < ActiveRecord::Migration[7.1]
  def change
    create_table :cryptocurrencies do |t|
      t.string :name
      t.string :code
      t.integer :monthly_rate
      t.decimal :last_price, precision: 12, scale: 4

      t.timestamps
    end
  end
end
