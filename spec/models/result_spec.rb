# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::Result do
  describe 'attr_readers' do
    let(:subject) { described_class.new }
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:label) }
    it { is_expected.to respond_to(:date) }
    it { is_expected.to respond_to(:cumulative_confirmed) }
    it { is_expected.to respond_to(:delta_confirmed) }
    it { is_expected.to respond_to(:cumulative_deaths) }
    it { is_expected.to respond_to(:delta_deaths) }
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
      let(:result) { described_class.for(raw_result) }

      it 'creates an instance with the values set' do # rubocop:disable RSpec/ExampleLength
        expect(result.id).to eq raw_result[:id]
        expect(result.label).to eq raw_result[:label]
        expect(result.date).to eq raw_result[:date]
        expect(result.cumulative_confirmed).to eq raw_result[:cumulative_confirmed]
        expect(result.delta_confirmed).to eq raw_result[:delta_confirmed]
        expect(result.cumulative_deaths).to eq raw_result[:cumulative_deaths]
        expect(result.delta_deaths).to eq raw_result[:delta_deaths]
      end

      it 'creates an instance with nil for error' do
        expect(result.error).to be_nil
      end

      it 'returns false for #error?' do
        expect(result.error?).to be false
      end
    end

    context 'when there is an error' do
      let(:raw_result) do
        {
          error: 'No data on 2020-05-30 for country_iso: USA, province_state: Alabama, admin2_county: Butler'
        }
      end
      let(:result) { described_class.for(raw_result) }

      it 'creates an instance only error set' do
        expect(result.error).to eq raw_result[:error]
      end

      it 'creates an instance with nil for all attrs but error' do # rubocop:disable RSpec/ExampleLength
        expect(result.id).to be_nil
        expect(result.label).to be_nil
        expect(result.date).to be_nil
        expect(result.cumulative_confirmed).to be_nil
        expect(result.delta_confirmed).to be_nil
        expect(result.cumulative_deaths).to be_nil
        expect(result.delta_deaths).to be_nil
      end

      it 'returns true for #error?' do
        expect(result.error?).to be true
      end
    end
  end
end
