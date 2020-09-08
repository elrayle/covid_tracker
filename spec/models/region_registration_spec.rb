# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::RegionRegistration do
  describe 'attr_readers' do
    let(:subject) { described_class.new(country_iso: 'USA', province_state: 'New York', admin2_county: 'Broome') }
    it { is_expected.to respond_to(:country_iso) }
    it { is_expected.to respond_to(:province_state) }
    it { is_expected.to respond_to(:admin2_county) }
  end

  describe '.new' do
    context 'when country is not specified' do
      it 'raises Argument error' do
        expect { described_class.new }.to raise_error ArgumentError, 'country_iso is required'
      end
    end

    context 'when country is specified' do
      context 'and state is not specified' do
        context 'and county is specified' do
          it 'raises Argument error' do
            expect { described_class.new(country_iso: 'USA', admin2_county: 'Richmond') }
              .to raise_error ArgumentError, 'province_state must be defined to include admin2_county'
          end
        end
      end
    end
  end

  describe '#id' do
    context 'when county is not specified' do
      context 'and state is not specified' do
        let(:registration) { described_class.new(country_iso: 'USA') }
        it 'only includes USA' do
          expect(registration.id).to eq 'USA'
        end
      end

      context 'and state is specified' do
        let(:registration) { described_class.new(country_iso: 'USA', province_state: 'Virginia') }
        it 'includes USA and state' do
          expect(registration.id).to eq 'USA:Virginia'
        end
      end
    end

    context 'when state and county are specified' do
      let(:registration) { described_class.new(country_iso: 'USA', province_state: 'New York', admin2_county: 'Broome') }
      it 'includes USA, state, and county' do
        expect(registration.id).to eq 'USA:New_York:Broome'
      end
    end
  end

  describe '#label' do
    context 'when county is not specified' do
      context 'and state is not specified' do
        let(:registration) { described_class.new(country_iso: 'USA') }
        it 'only includes USA' do
          expect(registration.label).to eq 'USA '
        end
      end

      context 'and state is specified' do
        let(:registration) { described_class.new(country_iso: 'USA', province_state: 'Virginia') }
        it 'includes USA and state' do
          expect(registration.label).to eq 'Virginia, USA '
        end
      end
    end

    context 'when state and county are specified' do
      let(:registration) { described_class.new(country_iso: 'USA', province_state: 'New York', admin2_county: 'Broome') }
      it 'includes USA, state, and county' do
        expect(registration.label).to eq 'Broome, New York, USA '
      end
    end
  end
end
