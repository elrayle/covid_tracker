# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::RegionCount do
  include_context "shared raw datum in region 1"
  let(:datum) { datum_for_region_1_day_1 }

  subject { described_class.for(region_code: 'usa-alabama-butler', region_datum: datum) }

  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:region_id) }
  it { is_expected.to respond_to(:result_code) }
  it { is_expected.to respond_to(:result_label) }
  it { is_expected.to respond_to(:date) }
  it { is_expected.to respond_to(:cumulative_confirmed) }
  it { is_expected.to respond_to(:delta_confirmed) }
  it { is_expected.to respond_to(:cumulative_deaths) }
  it { is_expected.to respond_to(:delta_deaths) }

  describe '.find_by' do
    let(:existing_region_code) { 'usa-georgia-evans' }
    let(:region) { FactoryBot.create(:region, region_code: existing_region_code) }
    let!(:region_count_1) { FactoryBot.create(:region_count, region: region, date: "2020-03-01", counts: [15, 4, 7, 1]) }
    let!(:region_count_2) { FactoryBot.create(:region_count, region: region, date: "2020-03-02", counts: [16, 5, 8, 2]) }
    let!(:region_count_3) { FactoryBot.create(:region_count, region: region, date: "2020-03-03", counts: [17, 6, 9, 3]) }
    context 'when date not specified' do
      context 'and no records with region code' do
        it 'returns empty set' do
          expect(described_class.find_by(region_code: 'usa-kentucky-boone')).to be_empty
        end
      end

      context 'and there are matching records with region code' do
        it 'returns 1 record' do
          result = described_class.find_by(region_code: existing_region_code)
          expect(result.count).to eq 3
          expect(result.first).to be_kind_of described_class
        end
      end
    end

    context 'when date is specified' do
      context 'and no records match date' do
        it 'returns empty set' do
          result = described_class.find_by(region_code: existing_region_code, date: "2020-04-01")
          expect(result).to be_empty
        end
      end

      context 'and records for region exist for multiple days' do
        let(:existing_date) { "2020-03-02" }
        it 'returns only the record with the matching date' do
          result = described_class.find_by(region_code: existing_region_code, date: existing_date)
          expect(result.count).to eq 1
          expect(result.first).to be_kind_of described_class
          expect(result.first.date).to eq existing_date
        end

        it 'has foreign key to region table' do
          result = described_class.find_by(region_code: existing_region_code, date: existing_date).first
          region = CovidTracker::Region.find_by(id: result.region_id)
          expect(region.region_code).to eq existing_region_code
        end
      end
    end

    context 'when region_code is not specified' do
      it 'raises error' do
      end
    end
  end
end
