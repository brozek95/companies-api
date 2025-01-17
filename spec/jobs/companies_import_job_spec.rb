describe CompaniesImportJob, type: :job do
  subject(:run_job) { described_class.perform_now(file_path) }

  let(:file_path) { 'spec/fixtures/files/sample.csv' }
  let(:csv_data) do
    [
      { 'name' => 'Company 1', 'registration_number' => '123', 'street' => 'Street 1', 'postal_code' => '12345', 'city' => 'City 1', 'country' => 'Country 1' },
      { 'name' => 'Company 2', 'registration_number' => '456', 'street' => second_street, 'postal_code' => '67890', 'city' => 'City 2', 'country' => 'Country 2' }
    ]
  end
  let(:second_street) { 'Street 2' }
  let(:csv_double) { instance_double(CSV) }

  before do
    allow(CSV).to receive(:read).and_return(csv_data)
    allow(Rails.logger).to receive(:info)
  end

  context 'when all rows are valid' do
    it 'saves companies' do
      expect { run_job }.to change(Company, :count).by(2)
    end

    it 'saves addresses' do
      expect { run_job }.to change(Address, :count).by(2)
    end

    it 'logs success messages' do
      run_job
      expect(Rails.logger).to have_received(:info).with('Row 2 saved').once
      expect(Rails.logger).to have_received(:info).with('Row 3 saved').once
    end
  end

  context 'when some rows are invalid' do
    let(:second_street) { nil }

    it 'does not save any companies' do
      expect { run_job }.not_to change(Company, :count)
    end

    it 'does not save any addresses' do
      expect { run_job }.not_to change(Address, :count)
    end

    it 'logs error messages' do
      run_job
      expect(Rails.logger).to have_received(:info).with('Row 2 saved').once
      expect(Rails.logger).to have_received(:info).with("Row 3 not saved, errors: [\"Addresses street can't be blank\"]. ALL CHANGES ARE ROLLED BACK").once
    end
  end

  context 'when company already exists' do
    let(:company) { create(:company, name: 'Company 1', registration_number: '123') }

    before { company }

    it 'saves companies only 1 company' do
      expect { run_job }.to change(Company, :count).by(1)
    end

    it 'saves addresses' do
      expect { run_job }.to change(Address, :count).by(2)
    end

    it 'logs success messages' do
      run_job
      expect(Rails.logger).to have_received(:info).with('Row 2 saved').once
      expect(Rails.logger).to have_received(:info).with('Row 3 saved').once
    end
  end
end
