require "http/client"

module Ameba::GithubAction
  NAME = "Ameba"

  class Runner
    @owner : String
    @repo : String

    def initialize
      @workspace = ENV["GITHUB_WORKSPACE"]
      @sha = ENV["GITHUB_SHA"]
      @github_token = ENV["GITHUB_TOKEN"]
      @github_event_path = ENV["GITHUB_EVENT_PATH"]

      event = JSON.parse(File.read(@github_event_path))
      repository = event["repository"].as_h
      @owner = repository["owner"]["login"].as_s
      @repo = repository["name"].as_s
    end

    def run
      check_id = create_check
      results = run_ameba
      update_check(check_id, results)
    rescue
      update_check(check_id, "failure")
    end

    def create_check
      body = {
        "name"       => NAME,
        "head_sha"   => @sha,
        "status"     => "in_progress",
        "started_at" => Time.local,
      }

      response = HTTP::Client.post(
        url: "api.github.com/repos/#{@owner}/#{@repo}/check-runs",
        headers: headers,
        body: body.to_json,
        tls: OpenSSL::SSL::Context::Client.new
      )
      raise response.status_message.to_s unless response.success?
      JSON.parse(response.body)["id"].as_s
    end

    def run_ameba
      Ameba::Config.load.tap do |config|
        config.formatter = Formatter.new
        config.globs = ["#{@workspace}/**/*.cr"]
        Ameba.run config
      end.formatter.as(Formatter).result
    end

    def update_check(id, results)
      #
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
