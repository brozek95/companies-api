require 'csv'

class CompaniesImportJob < ApplicationJob
  CSV_FIRST_ROW_INDEX = 2

  queue_as :default

  def perform(file_path)
    ActiveRecord::Base.transaction do
      CSV.read(file_path, headers: true).each.with_index(CSV_FIRST_ROW_INDEX) do |row, index|
        find_or_initialize_company(row)
        assign_address(row)
        success = company.save
        log_result(index)

        raise ActiveRecord::Rollback unless success
      end
    end
  end

  private

  attr_reader :company

  def find_or_initialize_company(row)
    @company = Company.find_or_initialize_by(attributes(row, :company))
  end

  def assign_address(row)
    company.addresses.build(attributes(row, :address))
  end

  def attributes(row, model_name)
    COMPANIES_IMPORT[:models][model_name][:attributes].map do |attribute|
      [attribute.first, row[attribute.second]]
    end.to_h
  end

  def log_result(index)
    Rails.logger.info company.errors.present? ? error_message(index) : success_message(index)
  end

  def error_message(index)
    "Row #{index} not saved, errors: #{company.errors.full_messages}. ALL CHANGES ARE ROLLED BACK"
  end

  def success_message(index)
    "Row #{index} saved"
  end
end