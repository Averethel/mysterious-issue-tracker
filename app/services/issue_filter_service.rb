class IssueFilterService
  def initialize(filters)
    @filters = filters
  end

  def filter(issues)
    issues = filter_by_title(issues) if @filters[:title]
    issues = filter_by_description(issues) if @filters[:description]
    issues = filter_by_priority(issues) if @filters[:priority]
    issues = filter_by_status(issues) if @filters[:status]
    issues.where(@filters.except(:tite, :description, :priority, :status))
  end

private
  def filter_by_title(issues)
    issues.where('title ilike ?', "%#{@filters[:title]}%")
  end

  def filter_by_description(issues)
    issues.where('description ilike ?', "%#{@filters[:description]}%") 
  end

  def filter_by_priority(issues)
    values = @filters[:priority].map{ |s| Issue.priorities[s] }.compact
    issues.where(priority: values)
  end

  def filter_by_status(issues)
    values = @filters[:status].map{ |s| Issue.statuses[s] }.compact
    issues.where(status: values)
  end
end
