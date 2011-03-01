##
# This is a class that generates fake gems in the format we expect from
# Gemcutter. It's used by the db/seeds.rb file and the specs for this app. If you
# want populate your development database with useful dummy data, do "rake db:seed"
#
# If you want to create a Repository model from this class, simply do...
#
#   fake_push = FakeGem.new
#   Repository.do_post_hook fake_push.repository_metadata
#
class FakePush

  ROOT_PATH = File.expand_path(::Rails.root.to_s)

  SAMPLE_FILES = Dir["#{ROOT_PATH}/**/*"].map do |filename|
    File.expand_path(filename).sub(ROOT_PATH, "")[1..-1]
  end

  def name
    @name ||= Faker::Lorem.words.first
  end

  def description
    @description ||= Faker::Company.catch_phrase
  end

  def owner_name
    @owner_name ||= Faker::Name.name
  end

  def owner_username
    @owner_username ||= Faker::Internet.user_name[/\w+/]
  end

end