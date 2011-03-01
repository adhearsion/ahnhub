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
class FakeGem < FakePush

  def gem_metadata
    @gem ||= {
      "name" => name,
      "info" => description,
      "version" => version,
      "version_downloads" => version_downloads,
      "authors" => owner_name,
      "downloads" => downloads,
      "project_uri" => project_url,
      "homepage_uri" => homepage_url,
      "source_code_uri" => source_code_url
    }
  end

  def name
    @name ||= Faker::Lorem.words.first
  end

  def version
    @version ||= "#{rand 10}.#{rand 10}.#{rand 10}"
  end

  def version_downloads
    @version_downloads ||= rand(1000)
  end

  def downloads
    @downloads ||= rand(10000)
  end

  def project_url
    "http://rubygems.org/gems/#{name}"
  end

  def homepage_url
    Faker::Internet.domain_name
  end

  def source_code_url
    "http://github.com/#{owner_username}/#{name}"
  end

end