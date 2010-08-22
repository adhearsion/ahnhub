require 'spec_helper'

describe Repository do

  before do
    @example_github_push = <<-JSON
      {
        "before": "5aef35982fb2d34e9d9d4502f6ede1072793222d",
        "after": "de8251ff97ee194a289832576287d6f8ad74e3d0",
        "repository": {
          "url": "http://github.com/defunkt/github",
          "name": "github",
          "description": "You're lookin' at it.",
          "watchers": 5,
          "forks": 2,
          "private": 1,
          "owner": {
            "email": "chris@ozmm.org",
            "name": "defunkt"
          }
        },
        "commits": [
          {
            "id": "41a212ee83ca127e3c8cf465891ab7216a705f59",
            "url": "http://github.com/defunkt/github/commit/41a212ee83ca127e3c8cf465891ab7216a705f59",
            "author": {
              "email": "chris@ozmm.org",
              "name": "Chris Wanstrath"
            },
            "message": "okay i give in",
            "timestamp": "2008-02-15T14:57:17-08:00",
            "added": ["filepath.rb"]
          },
          {
            "id": "de8251ff97ee194a289832576287d6f8ad74e3d0",
            "url": "http://github.com/defunkt/github/commit/de8251ff97ee194a289832576287d6f8ad74e3d0",
            "author": {
              "email": "chris@ozmm.org",
              "name": "Chris Wanstrath"
            },
            "message": "update pricing a tad",
            "timestamp": "2008-02-15T14:36:34-08:00"
          }
        ],
        "ref": "refs/heads/master"
      }
    JSON
    @parsed_github_push = JSON.parse @example_github_push
  end

  describe ".from_github_push" do

    before do
      @repository = Repository.update_or_create_from_github_push @parsed_github_push
    end
    
    it "should update the Repository with the embedded metadata" do

      @repository.watchers.should == 5
      @repository.forks.should == 2

      new_payload = @parsed_github_push.clone
      new_payload["repository"].merge! "forks" => 100, "watchers" => 200

      repository_after = Repository.update_or_create_from_github_push new_payload

      @repository.reload.should == repository_after
      
      repository_after.forks.should == 100
      repository_after.watchers.should == 200
    end

    it "should convert 'private' to a boolean" do
      @repository.should be_private
      
      payload_with_private_repo = @parsed_github_push.clone
      payload_with_private_repo["repository"].merge! "private" => 0
      
      @repository.update_from_github_push payload_with_private_repo
      @repository.should_not be_private
    end

    describe "creation of commits" do
      it "should not create a commit if a commit already exists with the same id" do
        @repository.should have(2).commits
        
        @parsed_github_push["commits"] << {
            "id" => "8663acfeb4e22942ceb272f8f732dc2eecaf5a57",
            "url" => "http://github.com/defunkt/github/commit/8663acfeb4e22942ceb272f8f732dc2eecaf5a57",
            "author" => {
              "email" => "chris@ozmm.org",
              "name" => "Chris Wanstrath"
            },
            "message" => "twas brillig and the slithy toves did gyre and gimble in the wabe",
            "timestamp" => "2009-02-15T14:57:17-08:00",
            "added" => ["Rakefile"]
        }
        
        @repository.update_from_github_push @parsed_github_push
        @repository.should have(3).commits
      end
    end

  end

end
