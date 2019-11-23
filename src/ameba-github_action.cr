require "ameba"
require "./ameba-github_action/*"

Ameba::GithubAction::Runner.new.run
