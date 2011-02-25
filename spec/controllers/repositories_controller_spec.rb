require 'spec_helper'

describe RepositoriesController do

  describe "#do_post_hook" do

    let(:fake_push) { FakeRepository.new }

    it "should be installed on the root path on POSTs" do
      { :post => "/" }.should route_to(:controller => controller.controller_name, :action => 'do_post_hook')
    end

    it "should properly create a Repository" do
      Repository.destroy_all
      post :do_post_hook, :payload => fake_push.repository_metadata.to_json
      response.should be_success

      Repository.count.should == 1

      repo = Repository.first
      repo.name.should == fake_push.repository_name
      repo.should have(fake_push.commits.size).commits
    end

  end

  describe "#index" do
    it "should be installed on the root path on GETs" do
      { :get => "/" }.should route_to(:controller => controller.controller_name, :action => 'index')
    end
  end

end
