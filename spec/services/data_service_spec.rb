# frozen_string_literal: true

require 'spec_helper'

# TODO: Turn this into a model class for easier access to data
RSpec.describe CovidTracker::DataService do
  include_context "shared raw results in region 1"

  let(:registration) { region_registration_1 }
  let(:region_data) { region_1_data }
  let(:datum) { datum_for_region_1_day_1 }

  describe '.region_code' do
    include_context "shared region registration 1"
    let(:region_results) { CovidTracker::RegionResults.new(region_registration: registration, region_data: region_data) }
    it 'returns region code' do
      expect(described_class.region_code(region_results: region_results)).to eq region_1_code
    end
  end

  describe '.region_label' do
    let(:region_results) { CovidTracker::RegionResults.new(region_registration: registration, region_data: region_data) }
    it 'returns region label' do
      expect(described_class.region_label(region_results: region_results)).to eq region_1_label
    end
  end

  describe '.region_data' do
    let(:region_results) { CovidTracker::RegionResults.new(region_registration: registration, region_data: region_data) }
    it 'returns region label' do
      data = described_class.region_data(region_results: region_results)
      expect(data).to be_kind_of Array
      expect(data.first).to be_kind_of CovidTracker::RegionDatum
      expect(data.count).to eq 2
    end
  end

  describe '.result' do
    it "returns instance of result model" do
      expect(described_class.result(datum)).to be_kind_of CovidTracker::Result
    end
  end

  describe '.result_code' do
    it 'returns result code' do
      expect(described_class.result_code(datum)).to eq raw_result_region_1_day_1_code
    end
  end

  describe '.result_label' do
    it 'returns result label' do
      expect(described_class.result_label(datum)).to eq raw_result_region_1_day_1_label
    end
  end

  describe '.date' do
    it 'returns result date' do
      expect(described_class.date(datum)).to eq raw_request_date_1
    end
  end

  describe '.cumulative_confirmed' do
    it 'returns result cumulative_confirmed' do
      expect(described_class.cumulative_confirmed(datum)).to eq raw_result_region_1_day_1_cum_confirmed
    end
  end

  describe '.delta_confirmed' do
    it 'returns result delta_confirmed' do
      expect(described_class.delta_confirmed(datum)).to eq raw_result_region_1_day_1_delta_confirmed
    end
  end

  describe '.cumulative_deaths' do
    it 'returns result cumulative_deaths' do
      expect(described_class.cumulative_deaths(datum)).to eq raw_result_region_1_day_1_cum_deaths
    end
  end

  describe '.delta_deaths' do
    it 'returns result delta_deaths' do
      expect(described_class.delta_deaths(datum)).to eq raw_result_region_1_day_1_delta_deaths
    end
  end

  describe '.request' do
    it "returns instance of request model" do
      expect(described_class.request(datum)).to be_kind_of CovidTracker::Request
    end
  end

  describe '.country_iso' do
    it 'returns result country_iso' do
      expect(described_class.country_iso(datum)).to eq country_iso_label_region_1
    end
  end

  describe '.province_state' do
    it 'returns result province_state' do
      expect(described_class.province_state(datum)).to eq province_state_label_region_1
    end
  end

  describe '.admin2_county' do
    it 'returns result admin2_county' do
      expect(described_class.admin2_county(datum)).to eq admin2_county_label_region_1
    end
  end
end
