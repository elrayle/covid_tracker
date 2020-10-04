# frozen_string_literal: true

require 'spec_helper'

# TODO: Turn this into a model class for easier access to data
RSpec.describe CovidTracker::DataService do
  include_context "shared raw results"
  let(:raw_datum) { raw_datum_without_error }
  let(:datum) { CovidTracker::RegionDatum.for(raw_datum) }

  describe '.region_code' do
    include_context "shared raw results"
    let(:registration) { CovidTracker::RegionRegistration.new(country_iso: 'USA', province_state: 'Alabama', admin2_county: 'Butler') }
    let(:region_data) { [CovidTracker::RegionDatum.for(raw_datum_without_error), CovidTracker::RegionDatum.for(raw_datum_2)] }
    let(:region_results) { CovidTracker::RegionResults.new(region_registration: registration, region_data: region_data) }
    it 'returns region code' do
      expect(described_class.region_code(region_results: region_results)).to eq "usa-alabama-butler"
    end
  end

  describe '.region_label' do
    let(:registration) { CovidTracker::RegionRegistration.new(country_iso: 'USA', province_state: 'Alabama', admin2_county: 'Butler') }
    let(:region_data) { [CovidTracker::RegionDatum.for(raw_datum_without_error), CovidTracker::RegionDatum.for(raw_datum_2)] }
    let(:region_results) { CovidTracker::RegionResults.new(region_registration: registration, region_data: region_data) }
    it 'returns region label' do
      expect(described_class.region_label(region_results: region_results)).to eq "Butler, Alabama, USA"
    end
  end

  describe '.region_data' do
    let(:registration) { CovidTracker::RegionRegistration.new(country_iso: 'USA', province_state: 'New York', admin2_county: 'Butler') }
    let(:region_data) { [CovidTracker::RegionDatum.for(raw_datum_without_error), CovidTracker::RegionDatum.for(raw_datum_2)] }
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

  describe '.result_id' do
    it 'returns result id' do
      expect(described_class.result_id(datum)).to eq "2020-05-31_usa-alabama-butler"
    end
  end

  describe '.result_label' do
    it 'returns result label' do
      expect(described_class.result_label(datum)).to eq "Butler, Alabama, USA (2020-05-31)"
    end
  end

  describe '.date' do
    it 'returns result id' do
      expect(described_class.date(datum)).to eq "2020-05-31"
    end
  end

  describe '.cumulative_confirmed' do
    it 'returns result id' do
      expect(described_class.cumulative_confirmed(datum)).to eq 203
    end
  end

  describe '.delta_confirmed' do
    it 'returns result id' do
      expect(described_class.delta_confirmed(datum)).to eq 3
    end
  end

  describe '.cumulative_deaths' do
    it 'returns result id' do
      expect(described_class.cumulative_deaths(datum)).to eq 5
    end
  end

  describe '.delta_deaths' do
    it 'returns result id' do
      expect(described_class.delta_deaths(datum)).to eq 0
    end
  end

  describe '.request' do
    it "returns instance of request model" do
      expect(described_class.request(datum)).to be_kind_of CovidTracker::Request
    end
  end

  describe '.country_iso' do
    it 'returns result id' do
      expect(described_class.country_iso(datum)).to eq "USA"
    end
  end

  describe '.province_state' do
    it 'returns result id' do
      expect(described_class.province_state(datum)).to eq "Alabama"
    end
  end

  describe '.admin2_county' do
    it 'returns result id' do
      expect(described_class.admin2_county(datum)).to eq "Butler"
    end
  end
end
