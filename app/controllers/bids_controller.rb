class BidsController < ApplicationController

  def index
    countries = params[:countries]&.split(',') || []
    categories = params[:categories]&.split(',') || []
    channels = params[:channels]&.split(',') || []
    combinations = countries.product(categories).product(channels).map(&:flatten)
    bids = []

    if combinations.present?
      combinations.each do |combination|
        country, category, channel = combination[0], combination[1], combination[2]

        country_bids = country_bids(country)
        category_bids = category_bids(country_bids, category)
        bid = category_bids.find_by(channel: channel) || category_bids.find_by(channel: '*') || country_bids.find_by(category: '*', channel: '*')

        bid = Bid.default.first unless bid

        bids << { 'country': country, 'category': category, channel: channel, 'amount': bid.amount } if bid
      end
    end

    render json: { bids: bids }, status: :ok
  end

  private

  def country_bids(country)
    country_bids = Bid.where(country: country)
    country_bids = Bid.where(country: '*') if country_bids.blank?
    country_bids
  end

  def category_bids(country_bids, category)
    category_bids = country_bids.where(category: category)
    category_bids = country_bids.where(category: '*') if category_bids.blank?
    category_bids
  end

end
