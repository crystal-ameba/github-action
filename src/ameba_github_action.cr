require "ameba"
require "./ameba_github_action/*"

begin
  exit Ameba::GithubAction::Runner.new.run ? 0 : 1
rescue ex
  STDERR.puts "Error: #{ex.message}"
  exit 255
end
