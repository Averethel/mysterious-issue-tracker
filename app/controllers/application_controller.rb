class ApplicationController < ActionController::API
  before_action :prepare_page_params, only: [:index]

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :invalid_params

  private

  def prepare_page_params
    params[:page] ||= {}
  end

  def not_found(error)
    render json: {
      errors: [{
        status: '404',
        title: 'Record not found',
        detail: error.message
      }] }, status: :not_found
  end

  def invalid_params(error)
    render json: {
      errors: [{
        status: '422',
        title: 'Invalid JSON submitted',
        detail: error.message
      }] }, status: :unprocessable_entity
  end

  def validation_errors(errors)
    render json: {
      errors: errors.map do |field, message|
        {
          status: '422',
          title: "Invalid #{field}",
          detail: message
        }
      end
    }, status: :unprocessable_entity
  end
end
