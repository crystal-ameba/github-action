require "http/client"

module Ameba::GithubAction
  NAME            = "Ameba"
  GITHUB_API_HOST = "https://api.github.com"

  class Runner
    @repo : String

    def initialize
      @sha = ENV["GITHUB_SHA"]
      @repo = ENV["GITHUB_REPOSITORY"]
      @workspace = ENV["GITHUB_WORKSPACE"]
      @github_token = ENV["GITHUB_TOKEN"]
      is_initialized = true
    end

    def run
      check_id = create_check
      begin
        result = run_ameba
        update_check(check_id, result)
      rescue e
        puts e
        update_check(check_id, nil)
      end
    end

    def create_check
      body = {
        "name"       => NAME,
        "head_sha"   => @sha,
        "status"     => "in_progress",
        "started_at" => Time.local,
      }.to_json

      client = HTTP::Client.new(URI.parse(GITHUB_API_HOST))
      response = client.post("/repos/#{@repo}/check-runs", headers, body)

      raise response.body unless response.success?
      JSON.parse(response.body)["id"].as_i
    end

    def run_ameba
      Ameba::Config.load.tap do |config|
        config.formatter = Formatter.new(@workspace)
        config.globs = ["#{@workspace}/**/*.cr"]
        Ameba.run config
      end.formatter.as(Formatter).result
    end

    def update_check(id, result)
      conclusion = result.try(&.success?) ? "success" : "failure"

      body = {
        "name"         => NAME,
        "head_sha"     => @sha,
        "status"       => "completed",
        "completed_at" => Time.local,
        "conclusion"   => conclusion,
        "output"       => result,
      }.to_json

      response = HTTP::Client.patch(
        url: "#{GITHUB_API_HOST}/repos/#{@repo}/check-runs/#{id}",
        headers: headers,
        body: body
      )
      raise response.status_message.to_s unless response.success?
    end

    private def headers
      @headers ||= HTTP::Headers{
        "Content-Type"  => "application/json",
        "Accept"        => "application/vnd.github.antiope-preview+json",
        "Authorization" => "Bearer #{@github_token}",
        "User-Agent"    => "ameba-action",
      }
    end
  end
end
