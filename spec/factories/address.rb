FactoryBot.define do
  factory :address, class: Address do
    street { 'Random street' }
    city { 'Random city' }
    postal_code { '12345' }
    country { 'Random country' }
    company { create(:company) }
  end
end
