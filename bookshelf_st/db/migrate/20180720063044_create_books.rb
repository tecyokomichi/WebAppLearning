class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.boolean :is_lended, default: false, null: false
      
      t.references :author

      t.timestamps
    end
  end
end
