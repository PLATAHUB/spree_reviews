# Add access to reviews/ratings to the product model
module Spree
  module ProductDecorator

    def self.prepended(base)
      base.has_many :reviews
    end

    def stars
      avg_rating.try(:round) || 0
    end

    def recalculate_rating
      self[:reviews_count] = reviews.reload.default_approval_filter.count
      self[:avg_rating] = reviews_count.positive? ? reviews.default_approval_filter.sum(:rating).to_f / reviews_count : 0
      save
    end
  end
end

Spree::Product.prepend Spree::ProductDecorator
