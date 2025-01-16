class CompaniesController < ApplicationController
  rescue_from StandardError, with: :internal_server_error

  before_action { validation_failed(errors) if errors.present? }

  def create
    company.save ? created(serialized_json) : validation_failed(company.errors.full_messages)
  end

  private

  def errors
    @errors ||= CompanyAttributesValidator.new(params).call
  end

  def company
    @company ||= Company.new(company_params)
  end

  def company_params
    params.require(:company).permit(:name, :registration_number, addresses_attributes: [:street, :city, :postal_code, :country])
  end

  def serialized_json
    company.as_json(include: :addresses)
  end
end
