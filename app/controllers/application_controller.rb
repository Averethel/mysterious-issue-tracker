class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found(error)
    render json: {
      errors: [{
        status: '404',
        title: 'Record not found',
        detail: error.message
      }] }, status: :not_found
  end
end
