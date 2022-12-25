# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bid, type: :model do

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  end

  describe 'Callbacks' do
    it { is_expected.to callback(:set_defaults).before(:save) }
  end

  describe 'Scopes' do
    let!(:bid) { create(:bid) }
    let!(:default_bid) { create(:bid, country: '*', category: '*', channel: '*') }

    context '.default' do
      it { expect(Bid.default).to include(default_bid) }
      it { expect(Bid.default).not_to include(bid) }
    end
  end

  describe 'Instance Methods' do

    describe '#set_defaults' do
      let(:bid) { create(:bid, country: nil) }

      before do
        bid.send(:set_defaults)
      end

      it 'set all default columns to default' do
        expect(bid.country).not_to be_nil
      end
    end
  end
end
