require "ameba"
require "./ameba_github_action/*"

Ameba::GithubAction::Runner.new.run
