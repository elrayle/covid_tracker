# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::Request do
  describe 'attr_readers' do
    let(:subject) { described_class.new }
    it { is_expected.to respond_to(:date) }
    it { is_expected.to respond_to(:country_iso) }
    it { is_expected.to respond_to(:province_state) }
    it { is_expected.to respond_to(:admin2_county) }
  end

  describe '.for' do
    context 'when request includes all parts' do
      let(:raw_request) do
        {
          date: "2020-05-31",
          country_iso: "USA",
          province_state: "New York",
          admin2_county: "Cortland"
        }
      end
      let(:request) { described_class.for(raw_request) }

      it 'creates an instance with the values set' do
        expect(request.date).to eq raw_request[:date]
        expect(request.country_iso).to eq raw_request[:country_iso]
        expect(request.province_state).to eq raw_request[:province_state]
        expect(request.admin2_county).to eq raw_request[:admin2_county]
      end
    end

    context 'when request includes country and state' do
      let(:raw_request) do
        {
          date: "2020-05-31",
          country_iso: "USA",
          province_state: "New York",
        }
      end
      let(:request) { described_class.for(raw_request) }

      it 'creates an instance with the country and state values set' do
        expect(request.date).to eq raw_request[:date]
        expect(request.country_iso).to eq raw_request[:country_iso]
        expect(request.province_state).to eq raw_request[:province_state]
      end

      it 'creates an instance with nil for county' do
        expect(request.admin2_county).to be_nil
      end
    end

    context 'when request includes only country' do
      let(:raw_request) do
        {
          date: "2020-05-31",
          country_iso: "USA",
        }
      end
      let(:request) { described_class.for(raw_request) }

      it 'creates an instance with the country and state values set' do
        expect(request.date).to eq raw_request[:date]
        expect(request.country_iso).to eq raw_request[:country_iso]
      end

      it 'creates an instance with nil for county' do
        expect(request.province_state).to be_nil
        expect(request.admin2_county).to be_nil
      end
    end
  end
end
