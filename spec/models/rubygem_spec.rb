require 'spec_helper'

describe Rubygem do

  let(:example_gemcutter_push) do
    <<-JSON
      {
        "name": "rails",
        "info": "Rails is a framework for building web-applications.",
        "version": "2.3.5",
        "version_downloads": 2451,
        "authors": "David Heinemeier Hansson",
        "downloads": 134451,
        "project_uri": "http://rubygems.org/gems/rails",
        "gem_uri": "http://rubygems.org/gems/rails-2.3.5.gem",
        "homepage_uri": "http://www.rubyonrails.org/",
        "wiki_uri": "http://wiki.rubyonrails.org/",
        "documentation_uri": "http://api.rubyonrails.org/",
        "mailing_list_uri": "http://groups.google.com/group/rubyonrails-talk",
        "source_code_uri": "http://gemcutter.com/rails/rails",
        "bug_tracker_uri": "http://rails.lighthouseapp.com/projects/8994-ruby-on-rails"
      }
    JSON
  end

  let(:parsed_gemcutter_push) { JSON.parse example_gemcutter_push }

  describe "#from_gemcutter_push" do

    subject { Rubygem.update_or_create_from_gemcutter_push parsed_gemcutter_push }

    its(:name) { should == "rails" }
    its(:info) { should == "Rails is a framework for building web-applications." }
    its(:version) { should == "2.3.5" }
    its(:version_downloads) { should == 2451 }
    its(:authors) { should == "David Heinemeier Hansson" }
    its(:downloads) { should == 134451 }
    its(:project_uri) { should == "http://rubygems.org/gems/rails" }
    its(:homepage_uri) { should == "http://www.rubyonrails.org/" }
    its(:source_code_uri) { should == "http://gemcutter.com/rails/rails" }

    it "should update the Rubygem with the embedded metadata" do
      parsed_gemcutter_push.merge! "version" => "2.3.6"

      rubygem_after = Rubygem.update_or_create_from_gemcutter_push parsed_gemcutter_push

      subject.reload.should == rubygem_after

      rubygem_after.version.should == "2.3.6"
    end

  end

end
