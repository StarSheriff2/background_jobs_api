module Groq
  module Chat
    module Completions
      class Prompt < ApplicationService
        def call(prompt, client)
          @prompt = prompt
          @client = client

          success @client.chat.completions(@prompt)
        end
      end
    end
  end
end
