class CreateSections < ActiveRecord::Migration[5.1]
  def change
    create_table :sections do |t|
      t.references :employee, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
