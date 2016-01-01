class AddDatesToDogs < ActiveRecord::Migration
  def change
    add_column :dogs, :post_date, :date
  end
end
