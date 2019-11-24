require "http/client"

module Ameba::GithubAction
  NAME = "Ameba"
  GITHUB_API_URL = "https://api.github.com"

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
      result = run_ameba
      update_check(check_id, result)
    rescue e
      puts e
      update_check(check_id, nil)
    end

    def create_check
      body = {
        "name"       => NAME,
        "head_sha"   => @sha,
        "status"     => "in_progress",
        "started_at" => Time.local,
      }.to_json

      response = HTTP::Client.post(
        url: "#{GITHUB_API_URL}/repos/#{@owner}/#{@repo}/check-runs",
        headers: headers,
        body: body
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

    def update_check(id, result)
      conclusion = result.try(&.success?) ? "success" : "failure"

      body = {
        "name" => NAME,
        "head_sha" => @sha,
        "status" => "completed",
        "completed_at" => Time.local,
        "conclusion" => conclusion,
        "output" => result
      }.to_json

      response = HTTP::Client.patch(
        url: "#{GITHUB_API_URL}/repos/#{@owner}/#{@repo}/check-runs/#{id}",
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
