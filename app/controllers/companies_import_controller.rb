class CompaniesImportController < ApplicationController
  def create
    return bad_request('No file uploaded') unless file.present?
    return validation_failed('Invalid file format - csv required') unless csv_file?

    handle_file
    ok('File uploaded successfully, processing will start soon - check sidekiq logs for details.')
  end

  private

  def file
    params[:file]
  end

  def csv_file?
    file.content_type == 'text/csv'
  end

  def handle_file
    CompaniesImportHandler.new(file).call
  end
end
