class ApplicationController < ActionController::API
  include ApiResponses

  rescue_from StandardError, with: :internal_server_error
end
