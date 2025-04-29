require "open-uri"

class ScrapeAndSummarizeJob < ApplicationJob
  queue_as :default

  def perform(url)
    html = URI.open(url).read
    doc = Nokogiri::HTML(html)
    paragraphs = doc.css("p").map(&:text).join(" ")
    summary = summarize(paragraphs)
    Rails.logger.info("Summary: #{summary}")
  end

  def summarize(text)
    "Summary: #{text[0..250]}..." # Mock summary
  end
end
