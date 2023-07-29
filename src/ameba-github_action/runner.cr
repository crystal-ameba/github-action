require "./github_client"

module Ameba::GithubAction
  NAME = "Ameba"

  class Runner
    def initialize(
      @workspace = ENV["GITHUB_WORKSPACE"],
      @sha = ENV["GITHUB_SHA"],
      @repo = ENV["GITHUB_REPOSITORY"],
      github_token = ENV["GITHUB_TOKEN"]
    )
      @github_client = GithubClient.new(github_token)
    end

    def run
      check_id = create_check
      begin
        result = run_ameba
        update_check(check_id, result)
      rescue e
        update_check(check_id, nil)
        raise e
      end
    end

    def create_check
      body = {
        "name"       => NAME,
        "head_sha"   => @sha,
        "status"     => "in_progress",
        "started_at" => Time.local,
      }.to_json

      response = @github_client.post("/repos/#{@repo}/check-runs", body)
      response["id"]
    end

    def ameba_config
      filepath = "#{@workspace}/.ameba.yml"
      filepath = nil unless File.exists?(filepath)

      Ameba::Config.load(path: filepath).tap do |config|
        config.formatter = Formatter.new(@workspace)
        config.globs = ["#{@workspace}/**/*.cr", "!#{@workspace}/lib/**/*.cr"]
      end
    end

    def run_ameba
      ameba_config
        .tap { |config| Ameba.run(config) }
        .formatter.as(Formatter).result
    end

    def update_check(id, result)
      body = {
        "name"         => NAME,
        "head_sha"     => @sha,
        "status"       => "completed",
        "completed_at" => Time.local,
        "conclusion"   => result.try(&.success?) ? "success" : "failure",
        "output"       => result,
      }.to_json

      @github_client.patch("/repos/#{@repo}/check-runs/#{id}", body)
    end
  end
end
