# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::RegionCount do
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
  subject { described_class.new(region_code: 'usa-alabama-butler', response: datum) }
  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:region_id) }
  it { is_expected.to respond_to(:date) }
  it { is_expected.to respond_to(:confirmed_cases) }
  it { is_expected.to respond_to(:delta_cases) }
  it { is_expected.to respond_to(:confirmed_deaths) }
  it { is_expected.to respond_to(:delta_deaths) }

  describe '.find_by' do
    context 'when date not specified' do
      context 'and no records with region code' do
        let(:region) { FactoryBot.create(:region, region_code: 'usa-georgia-evans') }
        let!(:region_count) { FactoryBot.create(:region_count, region: region, date: "2020-03-01", counts: [5, 1, 2, 2]) }
        it 'returns empty set' do
          expect(described_class.find_by(region_code: 'usa-kentucky-boone')).to be_empty
        end
      end

      context 'and only one record with region code' do
        it 'returns 1 record' do
        end
      end
    end

    context 'when date is specified' do
      context 'and no records match date' do
        it 'returns empty set' do
        end
      end

      context 'and records for region exist for multiple days' do
        it 'returns only the record with the matching date' do
        end
      end
    end

    context 'when region_code is not specified' do
      it 'raises error' do
      end
    end
  end
end
