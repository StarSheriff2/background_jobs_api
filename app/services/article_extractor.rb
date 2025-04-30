require "open-uri"

class ArticleExtractor
  def initialize(url)
    @url = url
    @doc = Nokogiri::HTML(URI.open(url))
  end

  def call
    extract_text_and_format
  end

  def extract_text_and_format
    article_element = find_article
    article_element.css("p, h2, h3").map(&:text).join("\n\n")
  end

  def find_article
    candidates = score_article_candidates

    candidates.max_by { |c| c[:score] }[:node]
  end

  def score_article_candidates
    filtered =  filter_dom_nodes
    filtered.map do |node|
      text = node.css("p").map(&:text).join(" ")
      score = text.length + (node.css("p").size * 100) # weigh paragraph count
      { node: node, score: score }
    end
  end

  def filter_dom_nodes
    keywords = %w[article content main post body story]
    @doc.css("div, section").select do |node|
      cls = node["class"].to_s.downcase
      keywords.any? { |k| cls.include?(k) }
    end
  end
end
