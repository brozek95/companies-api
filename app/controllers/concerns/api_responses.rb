module ApiResponses
  def ok(data)
    render json: data, status: :ok
  end

  def created(data)
    render json: data, status: :created
  end

  def bad_request(errors = [{ title: 'Invalid request' }])
    render json: { errors: errors }, status: :bad_request
  end

  def internal_server_error(errors = [{ title: 'Internal server error' }])
    render json: { errors: errors }, status: :internal_server_error
  end

  def validation_failed(errors)
    render json: { errors: errors }, status: :unprocessable_entity
  end
end
