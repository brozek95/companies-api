class CompaniesImportHandler
  def initialize(uploaded_file)
    @uploaded_file = uploaded_file
  end

  def call
    save_temp_file
    process_file
  end

  private

  attr_reader :uploaded_file

  def save_temp_file
    File.open(file_path, "wb") { |file| file.write(uploaded_file.read) }
  end

  def file_path
    @file_path ||= Rails.root.join("tmp", uploaded_file.original_filename)
  end

  def process_file
    CompaniesImportJob.perform_later(file_path.to_s)
  end
end
