class Address < ApplicationRecord
  belongs_to :company

  validates :street, :city, :country, presence: true, length: { maximum: DEFAULT_SQL_STRING_LENGTH }
  validates :postal_code, length: { maximum: DEFAULT_SQL_STRING_LENGTH }
end
