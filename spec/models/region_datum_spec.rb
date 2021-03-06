# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::RegionDatum do
  include_context "shared raw datum in region 1"

  describe 'attr_readers' do
    let(:subject) { described_class.new }
    it { is_expected.to respond_to(:result) }
    it { is_expected.to respond_to(:request) }
  end

  describe '.for and #error?' do
    context 'when no error' do
      let(:raw_datum) { raw_datum_region_1_day_1 }
      let(:region_datum) { described_class.for(raw_datum) }

      it 'creates an instance with the values set' do
        expect(region_datum.result).to be_kind_of CovidTracker::Result
        expect(region_datum.request).to be_kind_of CovidTracker::Request
      end

      it 'returns false for #error?' do
        expect(region_datum.error?).to be false
      end
    end

    context 'when there is an error' do
      let(:raw_datum) { raw_datum_region_1_day_1_with_error }
      let(:region_datum) { described_class.for(raw_datum) }

      it 'creates an instance with the values set' do
        expect(region_datum.result).to be_kind_of CovidTracker::Result
        expect(region_datum.request).to be_kind_of CovidTracker::Request
      end

      it 'returns true for #error?' do
        expect(region_datum.error?).to be true
      end
    end
  end
end
