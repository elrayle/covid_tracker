# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::Result do
  include_context "shared raw result region 1"

  describe 'attr_readers' do
    let(:subject) { described_class.new }
    it { is_expected.to respond_to(:result_code) }
    it { is_expected.to respond_to(:result_label) }
    it { is_expected.to respond_to(:date) }
    it { is_expected.to respond_to(:cumulative_confirmed) }
    it { is_expected.to respond_to(:delta_confirmed) }
    it { is_expected.to respond_to(:cumulative_deaths) }
    it { is_expected.to respond_to(:delta_deaths) }
  end

  describe '.for and #error?' do
    context 'when no error' do
      let(:raw_result) { raw_result_region_1_day_1 }
      let(:result) { described_class.for(raw_result) }

      it 'creates an instance with the values set' do # rubocop:disable RSpec/ExampleLength
        expect(result.id).to be_nil
        expect(result.result_code).to eq raw_result[:result_code]
        expect(result.result_label).to eq raw_result[:result_label]
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
      let(:raw_result) { raw_result_region_1_day_1_with_error }
      let(:result) { described_class.for(raw_result) }

      it 'creates an instance with only error set' do
        expect(result.error).to eq raw_result[:error]
      end

      it 'creates an instance with nil for all attrs but error' do # rubocop:disable RSpec/ExampleLength
        expect(result.id).to be_nil
        expect(result.result_code).to be_nil
        expect(result.result_label).to be_nil
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

  describe '.parse_result' do
    include_context "shared raw request dates"
    include_context "shared region registration 1"

    let(:result_code) { '2020-03-01-usa-georgia-evans' }
    let(:result_label) { 'Evans, Georgia, USA (2020-03-01)' }
    let(:existing_region_code) { 'usa-georgia-evans' }
    let(:region) { FactoryBot.create(:region, region_code: existing_region_code) }
    let!(:region_count_1) do
      FactoryBot.create(:region_count, region: region, date: "2020-03-01",
                                       result_code: result_code, result_label: result_label,
                                       counts: [15, 4, 7, 1])
    end

    let(:result) { described_class.parse_result(count_data: region_count_1) }

    it 'returns populated result' do # rubocop:disable RSpec/ExampleLength
      expect(result.id).to eq region_count_1.id
      expect(result.result_code).to eq result_code
      expect(result.result_label).to eq result_label
      expect(result.date).to eq "2020-03-01"
      expect(result.cumulative_confirmed).to eq 15
      expect(result.delta_confirmed).to eq 4
      expect(result.cumulative_deaths).to eq 7
      expect(result.delta_deaths).to eq 1
    end
  end
end
