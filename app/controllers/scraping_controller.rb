class ScrapingController < ApplicationController
  before_action :authenticate_user!

  def summarize
    ScrapeAndSummarizeJob.perform_later(params[:url])
    render json: { status: "Job started" }
  end
end
