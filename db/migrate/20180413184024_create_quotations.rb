class CreateQuotations < ActiveRecord::Migration[5.1]
  def change
    create_table :quotations do |t|
      t.string :code

      t.timestamps
    end
  end
end
