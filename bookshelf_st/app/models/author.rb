class Author < ApplicationRecord
  
  has_many :books, dependent: :destroy
  accepts_nested_attributes_for :books, allow_destroy: true
  
  scope :get_by_name, ->(name) {
    where("name like ?", "%#{name}%")
  }

end
