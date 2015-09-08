class AuthenticationService
  class AuthenticationError < StandardError; end

  def initialize(username: '', password: '')
    @username = username
    @password = password
  end

  def authenticate!
    user = User.find_by(username: @username)
    raise AuthenticationError if user.nil?
    user.authenticate(@password) || raise(AuthenticationError)
  end
end
