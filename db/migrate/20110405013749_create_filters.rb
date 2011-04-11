class CreateFilters < ActiveRecord::Migration
  def self.up
    create_table :filters do |t|
      t.string :name
      t.references :subscription

      t.timestamps
    end
  end

  def self.down
    drop_table :filters
  end
end
