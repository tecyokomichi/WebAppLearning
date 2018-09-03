class AddColumnBook < ActiveRecord::Migration[5.0]
  def change
    
    add_column :books, :book_kind, :integer, :after => :is_lended
    
  end
end
