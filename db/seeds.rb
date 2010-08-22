require 'digest/sha1'

50.times do
  fake_push = FakePush.new
  puts "Creating #{fake_push.qualified_github_name}: #{fake_push.description.inspect} with #{fake_push.commits.size} commits"
  Repository.update_or_create_from_github_push(fake_push.repository_metadata)
end
