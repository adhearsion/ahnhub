require 'spec_helper'

describe RepositoriesController do

  describe "#github_post_receive_hook" do

    before do
      @fake_push = FakeRepository.new
    end

    it "should be installed on the root path on POSTs" do
      params_from(:post, "/").should == {:controller => controller.controller_name, :action => "github_post_receive_hook"}
    end

    it "should properly create a Repository" do
      Repository.destroy_all
      post :github_post_receive_hook, :payload => @fake_push.repository_metadata.to_json
      response.should be_success

      Repository.count.should == 1

      repo = Repository.first
      repo.name.should == @fake_push.repository_name
      repo.should have(@fake_push.commits.size).commits
    end

  end

  describe "#index" do
    it "should be installed on the root path on GETs" do
      params_from(:get, "/").should == {:controller => controller.controller_name, :action => "index"}
    end
  end

end
