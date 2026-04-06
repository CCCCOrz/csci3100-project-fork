class EnablePgTrgmForItemSearch < ActiveRecord::Migration[8.1]
  def change
    enable_extension "pg_trgm" unless extension_enabled?("pg_trgm")

    add_index :items, :name, using: :gin, opclass: :gin_trgm_ops
    add_index :items, :description, using: :gin, opclass: :gin_trgm_ops
    add_index :items, :category
    add_index :items, :status
    add_index :items, :price
    add_index :items, :post_date
    add_index :users, :location
  end
end
