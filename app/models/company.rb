class Company < ApplicationRecord
  NAME_SIZE = 256

  has_many :addresses, dependent: :destroy

  accepts_nested_attributes_for :addresses

  validates :name, presence: true, length: { maximum: NAME_SIZE }
  validates :registration_number, 
            presence: true, 
            uniqueness: true,
            length: { maximum: DEFAULT_SQL_STRING_LENGTH },
            format: { with: /\A\d+\z/, message: "must contain only digits" }
  validates :addresses, presence: true
end
