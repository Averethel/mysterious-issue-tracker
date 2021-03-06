class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include Pundit

  before_action :check_authentication

  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: [:index]

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :invalid_params
  rescue_from AuthenticationService::AuthenticationError, with: :authentication_error
  rescue_from Pundit::NotAuthorizedError, with: :not_found_authorization

  private

  def page_params
    params.permit(page: [:size, :number])[:page] || {}
  end

  def not_found(error)
    render json: {
      errors: [{
        status: '404',
        title: 'Record not found',
        detail: error.message
      }] }, status: :not_found
  end

  def not_found_authorization(error)
    id = error.record.id
    message = "Couldn't find #{error.record.class} with 'id'=#{id}"
    not_found(OpenStruct.new(message: message))
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

  def authentication_error
    render json: {
      errors: [
        {
          status: '401',
          title: 'HTTP Basic: Access denied',
          detail: 'Invalid username or password'
        }
      ]
    }, status: :unauthorized
  end

  def current_user
    @current_user ||= User.new
  end

  def check_authentication
    authenticate_with_http_basic do |username, password|
      @current_user = AuthenticationService.new(
        username: username,
        password: password
      ).authenticate!
    end
  end
end
