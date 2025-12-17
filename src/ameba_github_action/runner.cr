module Ameba::GithubAction
  class Runner
    getter root : Path

    def initialize(root = ENV["GITHUB_WORKSPACE"])
      @root = Path[root]
    end

    def run : Nil
      Ameba.run(build_config)
    end

    private def build_config
      config = Config.load(root: root)
      config.formatter = Formatter::GitHubActionsFormatter.new
      config
    end
  end
end
