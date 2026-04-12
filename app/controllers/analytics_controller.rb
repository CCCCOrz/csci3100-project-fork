class AnalyticsController < ApplicationController
  def index
    @dashboard_summary = build_summary
    @category_chart = normalize_counts(Item.group(:category).count)
    @status_chart = normalize_counts(Item.group(:status).count, fallback_labels: %w[available reserved sold])
    @price_band_chart = price_band_counts
    @community_chart = normalize_counts(
      User.left_joins(:items).group(:location).count("items.id"),
      fallback_labels: User.where.not(location: [ nil, "" ]).distinct.order(:location).pluck(:location),
      preserve_case: true
    )
    @daily_posting_series = posting_series(30)
  end

  private

  def build_summary
    {
      total_items: Item.count,
      active_items: Item.where(status: "available").count,
      sold_items: Item.where(status: "sold").count,
      favorites: Favorite.count,
      average_price: Item.average(:price).to_f.round,
      sellers: User.joins(:items).distinct.count
    }
  end

  def normalize_counts(counts, fallback_labels: nil, preserve_case: false)
    labels = fallback_labels.presence || counts.keys

    {
      labels: labels.map { |label| normalized_label(label, preserve_case:) },
      values: labels.map { |label| counts[label].to_i }
    }
  end

  def price_band_counts
    bands = {
      "Under $100" => 0,
      "$100 - $499" => 0,
      "$500 - $999" => 0,
      "$1000+" => 0
    }

    Item.where.not(price: nil).find_each do |item|
      case item.price
      when 0...100
        bands["Under $100"] += 1
      when 100...500
        bands["$100 - $499"] += 1
      when 500...1000
        bands["$500 - $999"] += 1
      else
        bands["$1000+"] += 1
      end
    end

    {
      labels: bands.keys,
      values: bands.values
    }
  end

  def posting_series(days)
    start_date = days.days.ago.to_date
    counts_by_date = Item.group(Arel.sql("CAST(post_date AS date)")).count

    labels = []
    values = []

    start_date.upto(Date.current) do |date|
      labels << date.strftime("%b %-d")
      values << counts_by_date[date].to_i
    end

    {
      labels: labels,
      values: values
    }
  end

  def normalized_label(label, preserve_case: false)
    cleaned_label = label.to_s.strip
    return "Unspecified" if cleaned_label.blank?

    preserve_case ? cleaned_label : cleaned_label.titleize
  end
end
