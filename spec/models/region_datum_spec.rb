# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::RegionDatum do
  describe 'attr_readers' do
    let(:subject) { described_class.new }
    it { is_expected.to respond_to(:result) }
    it { is_expected.to respond_to(:request) }
  end

  describe '.for and #error?' do
    context 'when no error' do
      let(:raw_result) do
        {
          id: "2020-05-31_usa-new_york-cortland",
          label: "Cortland, New York, USA (2020-05-31)",
          region_code: "usa-new_york-cortland",
          region_label: "Cortland, New York, USA",
          date: "2020-05-31",
          cumulative_confirmed: 203,
          delta_confirmed: 3,
          cumulative_deaths: 5,
          delta_deaths: 0
        }
      end
      let(:raw_request) do
        {
          date: "2020-05-31",
          country_iso: "USA",
          province_state: "New York"
        }
      end
      let(:raw_datum) do
        {
          result: raw_result,
          request: raw_request
        }
      end

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
      let(:raw_result) do
        {
          error: 'No data on 2020-05-30 for country_iso: USA, province_state: Alabama, admin2_county: Butler'
        }
      end
      let(:raw_request) do
        {
          date: "2020-05-31",
          country_iso: "USA",
          province_state: "New York"
        }
      end
      let(:raw_datum) do
        {
          result: raw_result,
          request: raw_request
        }
      end

      let(:region_datum) { described_class.for(raw_datum) }

      it 'returns true for #error?' do
        expect(region_datum.error?).to be true
      end
    end
  end
end
