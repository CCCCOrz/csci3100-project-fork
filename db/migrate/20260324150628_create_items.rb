class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.string :category
      t.string :status
      t.references :seller, null: false, foreign_key: {to_table: :users}
      t.string :post_date

      t.timestamps
    end
  end
end
