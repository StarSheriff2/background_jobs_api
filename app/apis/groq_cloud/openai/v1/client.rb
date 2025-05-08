require "faraday"

module GroqCloud
  module Openai
    module V1
      class Client
        BASE_URL = "https://api.groq.com/openai/v1"

        attr_reader :api_key, :adapter

        def initialize(api_key:, adapter: Faraday.default_adapter, stubs: nil)
          @api_key = api_key
          @adapter = adapter

          # Test stubs for requests
          @stubs = stubs
        end

        def completions(prompt)
          request(
            http_method: :post,
            endpoint: "chat/completions",
            body: {
              model: "llama-3.3-70b-versatile",
              messages: [ {
                             role: "user",
                             content: prompt
                           } ]
            }
          )
        end

        private

        def client
          @client ||= begin
                        options = {
                          request: {
                            open_timeout: 10,
                            read_timeout: 10
                          }
                        }
                        Faraday.new(url: BASE_URL, **options) do |config|
                          config.request :authorization, :Bearer, api_key
                          config.request :json
                          config.response :json, parser_options: { symbolize_names: true }
                          config.response :raise_error
                          config.response :logger, Rails.logger, headers: true, bodies: true, log_level: :debug
                        end
                      end
        end

        def request(http_method:, endpoint:, body: {})
          response = client.public_send(http_method, endpoint, body)
          {
            status: response.status,
            body: response.body
          }
        rescue Faraday::Error => e
          puts e.inspect
        end
      end
    end
  end
end
