require 'spec_helper'

describe Plugin do
  it "requires a timestampe" do
    p = Plugin.new(name: "foo")
    expect {p.save}.to raise_error StandardError
  end

  describe "associations" do
    subject { Plugin.create(name: "foo", last_updated: Time.now) }

    describe "#has_rubygem?" do
      context "with no rubygem" do
        it { subject.has_rubygem?.should be_false }
      end

      context "when it has a rubygem" do
        before { subject.rubygem = Rubygem.new(name: "foo") }

        it { subject.has_rubygem?.should be_true }
      end
    end

    describe "#has_github?" do
      context "with no github" do
        it { subject.has_github?.should be_false }
      end

      context "when it has a github" do
        before { subject.github_repo = GithubRepo.new(name: "foo") }

        it { subject.has_github?.should be_true }
      end
    end
  end
end