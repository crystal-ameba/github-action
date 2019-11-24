require "http/client"

module Ameba::GithubAction
  GITHUB_API_HOST = "https://api.github.com"

  class GithubClient
    getter http

    def initialize(@github_token : String)
      @http = HTTP::Client.new(URI.parse(GITHUB_API_HOST))
    end

    def post(url, body)
      handle_response http.post(url, headers, body)
    end

    def patch(url, body)
      handle_response http.patch(url, headers, body)
    end

    private def handle_response(response)
      raise "Response: #{response.status_message}. Body: #{response.body}" unless response.success?
      JSON.parse(response.body)
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
