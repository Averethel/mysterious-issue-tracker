admin = User.create!(username: 'admin', role: :admin, password: 'admin', password_confirmation: 'admin')
5.times{ |i| User.create!(username: "user_#{i}", password: 'user', password_confirmation: 'user')}

10.times do |i|
  issue = Issue.create!(
    title: "Issue ##{i}",
    description: "Some very importatn description of issue #{i}",
    priority: Issue.priorities.keys.sample,
    creator: User.all.sample,

  )

  issue.update_attributes(status: Issue.statuses.keys.sample)
  if i % 3 != 0
    issue.update_attributes(assignee: User.all.sample)
  end
end

30.times do |i|
  Comment.create!(
    body: '+1',
    issue: Issue.all.sample,
    creator: User.all.sample
  )
end
