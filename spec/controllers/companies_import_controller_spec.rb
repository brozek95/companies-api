describe CompaniesImportController, type: :controller do
  describe '#create' do
    subject(:import_file) { post :create, params: file_params }

    let(:csv_file) { fixture_file_upload('/sample.csv', 'text/csv') }
    let(:handler) { CompaniesImportHandler }
    let(:handler_instance) { instance_double(handler) }

    context 'when internal server error occurs' do
      let(:file_params) { { file: csv_file } }
      let(:expected_error) { { errors: 'Internal server error' }.to_json }

      before do
        allow(handler).to receive(:new).and_return(handler_instance)
        allow(handler_instance).to receive(:call).and_raise(StandardError.new('Internal server error'))
      end

      it 'returns internal_server_error status' do
        import_file
        expect(response).to have_http_status(:internal_server_error)
      end

      it 'returns error message' do
        import_file
        expect(response.body).to eq(expected_error)
      end
    end

    context 'when no file is uploaded' do
      let(:file_params) { {} }
      let(:expected_error) { { errors: 'No file uploaded' }.to_json }

      it 'returns bad_request status' do
        import_file
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error message' do
        import_file
        expect(response.body).to eq(expected_error)
      end
    end

    context 'when invalid file format is uploaded' do
      let(:invalid_file) { fixture_file_upload('/sample.txt', 'text/plain') }
      let(:file_params) { { file: invalid_file } }
      let(:expected_error) { { errors: 'Invalid file format - csv required' }.to_json }

      it 'returns unprocessable_entity status' do
        import_file
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        import_file
        expect(response.body).to eq(expected_error)
      end
    end

    context 'when valid csv file is uploaded' do
      let(:file_params) { { file: csv_file } }

      before do
        allow(handler).to receive(:new).and_return(handler_instance)
        allow(handler_instance).to receive(:call)
      end

      it 'returns ok status' do
        import_file
        expect(response).to have_http_status(:ok)
      end

      it 'returns success message' do
        import_file
        expect(response.body).to eq('File uploaded successfully, processing will start soon - check sidekiq logs for details.')
      end
    end
  end
end
