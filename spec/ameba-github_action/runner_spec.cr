require "../spec_helper"

module Ameba::GithubAction
  describe Runner do
    subject = Runner.new(
      workspace: "./workspace",
      sha: "",
      repo: "",
      github_token: ""
    )

    describe "#ameba_config" do
      it "runs Ameba on a given workspace" do
        result = subject.ameba_config
        result.should_not be_nil
        result.formatter.should be_a Formatter
        result.globs.should eq ["./workspace/**/*.cr"]
      end
    end
  end
end
