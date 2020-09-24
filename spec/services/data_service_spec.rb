# frozen_string_literal: true

require 'spec_helper'

# TODO: Turn this into a model class for easier access to data
RSpec.describe CovidTracker::DataService do
  let(:datum) do
    {
      CovidTracker::RequestKeys::REQUEST_SECTION => 
        {
          CovidTracker::RequestKeys::DATE => "2020-04-01",
          CovidTracker::RequestKeys::COUNTRY_ISO => "USA",
          CovidTracker::RequestKeys::PROVINCE_STATE => "Alabama",
          CovidTracker::RequestKeys::ADMIN2_COUNTY => "Butler"
        },
      CovidTracker::ResultKeys::RESULT_SECTION =>
        {
          CovidTracker::ResultKeys::ID => "2020-04-01_usa-alabama-butler",
          CovidTracker::ResultKeys::LABEL => "Butler, Alabama, USA (2020-04-01)",
          CovidTracker::ResultKeys::REGION_ID => "usa-alabama-butler",
          CovidTracker::ResultKeys::REGION_LABEL => "Butler, Alabama, USA",
          CovidTracker::ResultKeys::DATE => "2020-04-01",
          CovidTracker::ResultKeys::CUMULATIVE_CONFIRMED => 20,
          CovidTracker::ResultKeys::DELTA_CONFIRMED => 2,
          CovidTracker::ResultKeys::CUMULATIVE_DEATHS => 5,
          CovidTracker::ResultKeys::DELTA_DEATHS => 1        
        }
    }    
  end

  describe '.result' do
    it "has result keys" do
      expect(described_class.result(datum).keys).to match_array [:id, :label, :region_id, :region_label, :date, 
                                                                 :cumulative_confirmed, :delta_confirmed, 
                                                                 :cumulative_deaths, :delta_deaths]
    end
  end

  describe '.result_id' do
    it 'returns result id' do
      expect(described_class.result_id(datum)).to eq "2020-04-01_usa-alabama-butler"
    end
  end

  describe '.result_label' do
    it 'returns result id' do
      expect(described_class.result_label(datum)).to eq "Butler, Alabama, USA (2020-04-01)"
    end
  end

  describe '.region_id' do
    it 'returns result id' do
      expect(described_class.region_id(datum)).to eq "usa-alabama-butler"
    end
  end

  describe '.region_label' do
    it 'returns result id' do
      expect(described_class.region_label(datum)).to eq "Butler, Alabama, USA"
    end
  end

  describe '.date' do
    it 'returns result id' do
      expect(described_class.date(datum)).to eq "2020-04-01"
    end
  end

  describe '.cumulative_confirmed' do
    it 'returns result id' do
      expect(described_class.cumulative_confirmed(datum)).to eq 20
    end
  end

  describe '.delta_confirmed' do
    it 'returns result id' do
      expect(described_class.delta_confirmed(datum)).to eq 2
    end
  end

  describe '.cumulative_deaths' do
    it 'returns result id' do
      expect(described_class.cumulative_deaths(datum)).to eq 5
    end
  end

  describe '.delta_deaths' do
    it 'returns result id' do
      expect(described_class.delta_deaths(datum)).to eq 1
    end
  end

  describe '.request' do
    it "has request keys" do
      expect(described_class.request(datum).keys).to match_array [:date, :country_iso, :province_state, :admin2_county]
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
