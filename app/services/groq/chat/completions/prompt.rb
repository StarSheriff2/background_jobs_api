module Groq
  module Chat
    module Completions
      class Prompt < ApplicationService
        def initialize(prompt, client)
          @prompt = prompt
          @client = client
        end

        def call
          response = @client.prompt(@prompt)
        end
      end
    end
  end
end
