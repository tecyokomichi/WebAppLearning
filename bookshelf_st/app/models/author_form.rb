class AuthorForm
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :name, String

  # validationが必要ならここにvalidatesを書ける
  #  validates :name, presence: true

  def search
    #@authors = Author.where("name LIKE ?", "%#{params[:name]}%")
    scoped = Author.scoped
    scoped = Author.where("name LIKE ?", "%#{name}%") if name.present?
    scoped
  end
end
