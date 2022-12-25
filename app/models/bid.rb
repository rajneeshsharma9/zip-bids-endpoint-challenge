# frozen_string_literal: true

class Bid < ApplicationRecord

  # Callbacks
  before_save :set_defaults

  # Scopes
  scope :default, -> { where(country: '*', category: '*', channel: '*') }

  # Validations
  validates :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }, allow_blank: true

  private

  def set_defaults
    default_attributes = [:category, :country, :channel]

    default_attributes.each do |attribute|
      self[attribute] = '*' if self[attribute].nil?
    end
  end

end
