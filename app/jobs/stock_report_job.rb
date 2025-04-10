class StockReportJob < ApplicationJob
  queue_as :critical

  def perform
    response = HTTParty.get("https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum&vs_currencies=usd")
    prices = response.parsed_response
    Rails.logger.info("Stock Report: #{prices}")
  end
end
