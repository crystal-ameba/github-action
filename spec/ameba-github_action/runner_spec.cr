require "../spec_helper"

class Ameba::GithubAction::Runner
  def build_config
    previous_def
  end
end

private def with_github_workspace(path, &)
  ENV["GITHUB_WORKSPACE"] = path
  yield
ensure
  ENV["GITHUB_WORKSPACE"] = nil
end

module Ameba::GithubAction
  describe Runner do
    describe "#root" do
      it "is set to the given argument" do
        runner = Runner.new("./foo")
        runner.root.should eq Path["./foo"]
      end

      it "is set to ENV['GITHUB_WORKSPACE'] by default" do
        with_github_workspace("./workspace") do
          runner = Runner.new
          runner.root.should eq Path["./workspace"]
        end
      end
    end

    describe "#build_config" do
      it "returns Ameba configuration" do
        with_github_workspace("./workspace") do
          runner = Runner.new
          config = runner.build_config

          config.root.should eq Path["./workspace"]
          config.formatter.should be_a Formatter::GitHubActionsFormatter
        end
      end
    end
  end
end
