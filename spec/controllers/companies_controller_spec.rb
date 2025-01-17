describe CompaniesController, type: :controller do
  describe '#create' do
    subject(:create_company) { post :create, params: { company: company_params } }

    let(:company_params) do
      {
        name: 'Company Name',
        registration_number: '123123',
        addresses_attributes: [
          { street: 'Street', city: 'City', postal_code: '12345', country: 'Country' }
        ]
      }
    end
    let(:validator) { CompanyAttributesValidator }
    let(:validator_instance) { instance_double(validator) }

    context 'when internal server error occurs' do
      before do
        allow(validator).to receive(:new).and_return(validator_instance)
        allow(validator_instance).to receive(:call).and_raise(StandardError.new('Internal server error'))
      end

      it 'does not create a new company' do
        expect { create_company }.not_to change(Company, :count)
      end

      it 'returns internal_server_error status' do
        create_company
        expect(response).to have_http_status(:internal_server_error)
      end

      it 'returns an error message' do
        create_company
        expect(response.body).to match(/\"errors\":\"Internal server error\"/)
      end
    end

    context 'when schema validation fails' do
      context 'by missing the company property' do
        let(:company_params) { {} }

        it 'does not create a new company' do
          expect { create_company }.not_to change(Company, :count)
        end

        it 'returns unprocessable_entity status' do
          create_company
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          create_company
          expect(response.body).to match(/\"errors\":\[\s*\"The property '#\/' did not contain a required property of 'company' in schema [0-9a-fA-F\-]{36}\"\s*\]/)
        end
      end
    end

    context 'when the company is invalid' do
      let(:same_registration_number) { '123123' }
      let(:company) { create(:company, registration_number: same_registration_number) }
      let(:address) { create(:address, company: company) }

      before { address }

      it 'does not create a new company' do
        expect { create_company }.not_to change(Company, :count)
      end

      it 'returns unprocessable_entity status' do
        create_company
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        create_company
        expect(response.body).to match(/\"errors\":\[\s*\"Registration number has already been taken\"\s*\]/)
      end
    end

    context 'when the company is valid' do
      it 'creates a new company' do
        expect { create_company }.to change(Company, :count).by(1)
      end

      it 'returns created status' do
        create_company
        expect(response).to have_http_status(:created)
      end

      it 'returns a serialized company' do
        create_company
        expect(response.body).to eq(Company.last.to_json(include: :addresses))
      end
    end
  end
end
