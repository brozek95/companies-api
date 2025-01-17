FactoryBot.define do
  factory :company, class: Company do
    name { 'Random company name' }
    registration_number { SecureRandom.hex(5) }
  end
end
