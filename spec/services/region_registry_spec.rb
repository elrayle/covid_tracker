# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::RegionRegistry do
  before { described_class.clear_registry }

  subject { described_class.registry }
  describe '.register_usa' do
    context 'when county is not specified' do
      context 'and state is not specified' do
        before { described_class.register_usa }
        let(:registration) { subject.first }
        it 'only includes USA' do
          expect(registration).to be_kind_of CovidTracker::RegionRegistration
          expect(registration.country_iso).to eq 'USA'
          expect(registration.province_state).to be_nil
          expect(registration.admin2_county).to be_nil
        end
      end

      context 'and state is specified' do
        before { described_class.register_usa(state: 'Virginia') }
        let(:registration) { subject.first }
        it 'includes USA and state' do
          expect(registration).to be_kind_of CovidTracker::RegionRegistration
          expect(registration.country_iso).to eq 'USA'
          expect(registration.province_state).to eq 'Virginia'
          expect(registration.admin2_county).to be_nil
        end
      end
    end

    context 'when state and county are specified' do
      before { described_class.register_usa(state: 'New York', county: 'Broome') }
      let(:registration) { subject.first }
      it 'includes USA, state, and county' do
        expect(registration).to be_kind_of CovidTracker::RegionRegistration
        expect(registration.country_iso).to eq 'USA'
        expect(registration.province_state).to eq 'New York'
        expect(registration.admin2_county).to eq 'Broome'
      end
    end
  end

  describe '.register' do
    context 'when country iso is specified' do
      context 'and admin2 is not specified' do
        context 'and province is not specified' do
          before { described_class.register(country_iso: 'CHN') }
          let(:registration) { subject.first }
          it 'only includes country iso' do
            expect(registration).to be_kind_of CovidTracker::RegionRegistration
            expect(registration.country_iso).to eq 'CHN'
            expect(registration.province_state).to be_nil
            expect(registration.admin2_county).to be_nil
          end
        end

        context 'and province is specified' do
          before { described_class.register(country_iso: 'DEU', province_state: 'Berlin') }
          let(:registration) { subject.first }
          it 'includes USA and state' do
            expect(registration).to be_kind_of CovidTracker::RegionRegistration
            expect(registration.country_iso).to eq 'DEU'
            expect(registration.province_state).to eq 'Berlin'
            expect(registration.admin2_county).to be_nil
          end
        end
      end

      context 'and admin2 and province are specified' do
        before { described_class.register(country_iso: 'USA', province_state: 'Georgia', admin2_county: 'Columbia') }
        let(:registration) { subject.first }
        it 'includes USA, state, and county' do
          expect(registration).to be_kind_of CovidTracker::RegionRegistration
          expect(registration.country_iso).to eq 'USA'
          expect(registration.province_state).to eq 'Georgia'
          expect(registration.admin2_county).to eq 'Columbia'
        end
      end
    end

    context 'when country iso is not specified' do
      it 'raises argument error exception' do
        expect { described_class.register }.to raise_error ArgumentError
      end
    end

    context 'when called multiple times' do
      before do
        described_class.register(country_iso: 'ALB')
        described_class.register(country_iso: 'AUS', province_state: 'Victoria')
        described_class.register(country_iso: 'USA', province_state: 'Colorado', admin2_county: 'Broomfield')
      end

      it 'has a registration for each country registered' do
        countries = subject.map(&:country_iso)
        expect(countries).to contain_exactly('USA', 'AUS', 'ALB')
      end

      it 'registers multiple regions' do # rubocop:disable RSpec/ExampleLength
        subject.each do |registration|
          case registration.country_iso
          when 'USA'
            expect(registration.country_iso).to eq 'USA'
            expect(registration.province_state).to eq 'Colorado'
            expect(registration.admin2_county).to eq 'Broomfield'
          when 'AUS'
            expect(registration.country_iso).to eq 'AUS'
            expect(registration.province_state).to eq 'Victoria'
            expect(registration.admin2_county).to be_nil
          when 'ALB'
            expect(registration.country_iso).to eq 'ALB'
            expect(registration.province_state).to be_nil
            expect(registration.admin2_county).to be_nil
          end
        end
      end
    end
  end
end
