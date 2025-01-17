describe CompanyAttributesValidator do
  subject(:validator) { described_class.new(params) }

  let(:params) { ActionController::Parameters.new(company: company_params) }
  let(:company_params) do
    {
      name: name,
      registration_number: registration_number,
      addresses_attributes: addresses_attributes
    }
  end
  let(:name) { 'Company Name' }
  let(:registration_number) { '123456789' }
  let(:addresses_attributes) { [ { street: street, city: 'City Name', postal_code: '12345', country: 'Country Name' } ] }
  let(:street) { 'Street Name' }

  context 'when the params are valid' do
    it 'does not return any errors' do
      expect(validator.call).to be_empty
    end
  end

  context 'when company is empty' do
    let(:company_params) { {} }

    it 'returns an error message for name' do
      expected_message = "The property '#/company' did not contain a required property of 'name' in schema"
      expect(validator.call.any? { |msg| msg.include?(expected_message) }).to be true
    end

    it 'returns an error message for registration_number' do
      expected_message = "The property '#/company' did not contain a required property of 'registration_number' in schema"
      expect(validator.call.any? { |msg| msg.include?(expected_message) }).to be true
    end

    it 'returns an error message for addresses_attributes' do
      expected_message = "The property '#/company' did not contain a required property of 'addresses_attributes' in schema"
      expect(validator.call.any? { |msg| msg.include?(expected_message) }).to be true
    end
  end

  context 'when name is empty' do
    let(:name) { nil }

    it 'returns an error message for name' do
      expected_message = "The property '#/company/name' of type null did not match the following type: string in schema"
      expect(validator.call.any? { |msg| msg.include?(expected_message) }).to be true
    end
  end

  context 'when name is longer than 256 characters' do
    let(:name) { 'a' * 257 }

    it 'returns an error message for name' do
      expected_message = "The property '#/company/name' was not of a maximum string length of 256 in schema"
      expect(validator.call.any? { |msg| msg.include?(expected_message) }).to be true
    end
  end

  context 'when registration_number is empty' do
    let(:registration_number) { nil }

    it 'returns an error message for registration_number' do
      expected_message = "The property '#/company/registration_number' of type null did not match the following type: string in schema"
      expect(validator.call.any? { |msg| msg.include?(expected_message) }).to be true
    end
  end

  context 'when registration_number is longer than 255 characters' do
    let(:registration_number) { '2' * 256 }

    it 'returns an error message for registration_number' do
      expected_message = "The property '#/company/registration_number' was not of a maximum string length of 255 in schema"
      expect(validator.call.any? { |msg| msg.include?(expected_message) }).to be true
    end
  end

  context 'when registration_number has non numeric characters' do
    let(:registration_number) { '123XYZ' }

    it 'returns an error message for registration_number' do
      expected_message = "The property '#/company/registration_number' value \"123XYZ\" did not match the regex '^[0-9]+$' in schema"
      expect(validator.call.any? { |msg| msg.include?(expected_message) }).to be true
    end
  end

  context 'when addresses_attributes is empty' do
    let(:addresses_attributes) { [] }

    it 'returns an error message for addresses_attributes' do
      expected_message = "The property '#/company/addresses_attributes' did not contain a minimum number of items 1 in schema"
      expect(validator.call.any? { |msg| msg.include?(expected_message) }).to be true
    end
  end

  context 'when addresses_attributes has inproper type' do
    let(:addresses_attributes) { 123 }

    it 'returns an error message for addresses_attributes' do
      expected_message = "The property '#/company/addresses_attributes' of type integer did not match the following type: array in schema"
      expect(validator.call.any? { |msg| msg.include?(expected_message) }).to be true
    end
  end

  context 'when addresses_attributes has not all required properties' do
    let(:addresses_attributes) { [ { city: 'City Name', postal_code: '12345', country: 'Country Name' } ] }

    it 'returns an error message for addresses_attributes' do
      expected_message = "The property '#/company/addresses_attributes/0' did not contain a required property of 'street' in schema"
      expect(validator.call.any? { |msg| msg.include?(expected_message) }).to be true
    end
  end

  context 'when addresses_attributes has extra properties' do
    let(:addresses_attributes) { [ { street: 'Street Name', city: 'City Name', postal_code: '12345', country: 'Country Name', random: 123 } ] }

    it 'returns an error message for addresses_attributes' do
      expected_message = "The property '#/company/addresses_attributes/0' contains additional properties [\"random\"] outside of the schema when none are allowed in schema"
      expect(validator.call.any? { |msg| msg.include?(expected_message) }).to be true
    end
  end

  context 'when addresses_attributes has invalid property' do
    let(:street) { 's' * 256 }

    it 'returns an error message for street' do
      expected_message = "The property '#/company/addresses_attributes/0/street' was not of a maximum string length of 255 in schema"
      expect(validator.call.any? { |msg| msg.include?(expected_message) }).to be true
    end
  end

  context 'when addresses_attributes has no postal_code' do
    let(:addresses_attributes) { [ { street: street, city: 'City Name', country: 'Country Name' } ] }

    it 'does not return any errors' do
      expect(validator.call).to be_empty
    end
  end
end
