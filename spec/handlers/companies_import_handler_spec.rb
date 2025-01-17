describe CompaniesImportHandler do
  subject(:handler) { described_class.new(uploaded_file) }

  let(:uploaded_file) { instance_double(ActionDispatch::Http::UploadedFile) }
  let(:file_name) { 'file.csv' }
  let(:temp_file_path) { Rails.root.join('tmp', file_name) }
  let(:job) { CompaniesImportJob }

  before do
    allow(uploaded_file).to receive(:read).and_return('file content')
    allow(uploaded_file).to receive(:original_filename).and_return(file_name)
    allow(job).to receive(:perform_later)
  end

  it 'saves temp file' do
    expect(File).to receive(:open).with(temp_file_path, 'wb').and_yield(file = double)
    expect(file).to receive(:write).with('file content')
    handler.call
  end

  it 'triggers CompaniesImportJob' do
    expect(job).to receive(:perform_later).with(temp_file_path.to_s)
    handler.call
  end
end
