class CreateManagers < ActiveRecord::Migration[5.1]
  def change
    create_table :managers do |t|
      t.references :employee, foreign_key: true
      t.references :section, foreign_key: true

      t.timestamps
    end
  end
end
