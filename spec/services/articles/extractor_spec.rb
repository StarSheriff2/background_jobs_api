require 'rails_helper'

RSpec.describe Articles::Extractor, type: :service do
  let(:url) { "http://example.com/article" }
  let(:html_content) do
    <<-HTML
      <html lang="en">
        <body>
          <div class="article">
            <p>First paragraph of the article.</p>
            <p>Second paragraph of the article.</p>
            <p>Related articles</p>
          </div>
        </body>
      </html>
    HTML
  end

  before do
    allow(URI).to receive(:open).with(url).and_return(StringIO.new(html_content))
  end

  describe ".call" do
    it "extracts and formats the article text" do
      result = described_class.call(url)

      expect(result.success?).to be true
      expect(result.payload).to eq("First paragraph of the article.Second paragraph of the article.")
    end
  end
end
