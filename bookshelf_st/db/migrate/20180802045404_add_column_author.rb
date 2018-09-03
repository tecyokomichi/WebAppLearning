class AddColumnAuthor < ActiveRecord::Migration[5.0]
  def change
    
    add_column :authors, :age, :integer, :after => :name
    
  end
end
