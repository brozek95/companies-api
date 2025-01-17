class CompanyAttributesValidator
  def initialize(params)
    @params = params
  end

  def call
    validator_errors
  end

  private

  attr_reader :params

  def validator_errors
    @validator_errors ||= JSON::Validator.fully_validate(schema, params.to_unsafe_h.slice(:company))
  end

  def schema
    JSON.parse(File.read(Rails.root.join("app/schemas/company_create_schema.json")))
  end
end
