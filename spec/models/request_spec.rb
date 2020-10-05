# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::Request do
  include_context "shared raw request levels"

  describe 'attr_readers' do
    let(:subject) { described_class.new }
    it { is_expected.to respond_to(:date) }
    it { is_expected.to respond_to(:country_iso) }
    it { is_expected.to respond_to(:province_state) }
    it { is_expected.to respond_to(:admin2_county) }
  end

  describe '.for' do
    context 'when request includes all parts' do
      let(:raw_request) { raw_request_upto_county }
      let(:request) { described_class.for(raw_request) }

      it 'creates an instance with the values set' do
        expect(request.date).to eq raw_request[:date]
        expect(request.country_iso).to eq raw_request[:country_iso]
        expect(request.province_state).to eq raw_request[:province_state]
        expect(request.admin2_county).to eq raw_request[:admin2_county]
      end
    end

    context 'when request includes country and state' do
      let(:raw_request) { raw_request_upto_state }
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
      let(:raw_request) { raw_request_upto_country }
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

  describe '.parse_request' do
    include_context "shared raw request dates"
    include_context "shared region registration 1"

    let(:request) { described_class.parse_request(region_registration: region_registration_1, date: raw_request_date_1) }

    it 'returns populated request' do
      expect(request.date).to eq raw_request_date_1
      expect(request.country_iso).to eq region_registration_1.country_iso
      expect(request.province_state).to eq region_registration_1.province_state
      expect(request.admin2_county).to eq region_registration_1.admin2_county
    end
  end
end
