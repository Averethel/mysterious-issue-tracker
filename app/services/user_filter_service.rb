class UserFilterService
  def initialize(filters)
    @filters = filters
  end

  def filter(users)
    users = filter_by_username(users) if @filters[:username]
    users.where(@filters.except(:username))
  end

private
  def filter_by_username(users)
    users.where('username ilike ?', "%#{@filters[:username]}%")
  end
end
