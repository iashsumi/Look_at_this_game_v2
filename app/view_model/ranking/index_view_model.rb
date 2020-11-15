# frozen_string_literal: true

class Ranking::IndexViewModel
  def initialize(today_summary, prev_summary)
    @today_summary = today_summary
    @prev_summary = prev_summary
  end

  def to_json
    {
      today: fetch_summary(@today_summary),
      yesterday: fetch_summary(@prev_summary)
    }
  end

  private
    def fetch_summary(summary)
      summary.map do |item|
        {
          title: item.title,
          count: item.count
        }
      end
    end
end
