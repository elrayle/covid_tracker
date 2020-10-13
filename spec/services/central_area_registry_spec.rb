# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::CentralAreaRegistry do
  include_context "shared central area registration 1"

  before { described_class.clear_registry }

  subject { described_class.registry }
  describe '.register_usa' do
    context 'when regions is not specified' do
      it 'raises Argument error' do
        expect { described_class.register_usa }.to raise_error ArgumentError, 'regions is required'
      end
    end

    context 'when county is not specified' do
      let(:central_area_codes) { subject.keys }
      let(:central_area_code) { central_area_codes.first }
      let(:registration) { subject[central_area_code] }

      context 'and state is not specified' do
        before { described_class.register_usa(regions: central_area_1_regions) }
        it 'only includes USA' do
          expect(central_area_code).to eq 'usa'
          expect(registration).to be_kind_of CovidTracker::CentralAreaRegistration
          expect(registration.country_iso).to eq 'USA'
          expect(registration.province_state).to be_nil
          expect(registration.admin2_county).to be_nil
        end
      end

      context 'and state is specified' do
        before { described_class.register_usa(regions: central_area_1_regions, state: 'Virginia') }
        it 'includes USA and state' do
          expect(central_area_code).to eq 'usa-virginia'
          expect(registration).to be_kind_of CovidTracker::CentralAreaRegistration
          expect(registration.country_iso).to eq 'USA'
          expect(registration.province_state).to eq 'Virginia'
          expect(registration.admin2_county).to be_nil
        end
      end
    end

    context 'when county is specified' do
      context 'and state is not specified' do
        it 'raises ArgumentError' do
          expect { described_class.register_usa(regions: central_area_1_regions, county: 'Broome') }
            .to raise_error ArgumentError, 'province_state must be defined to include admin2_county'
        end
      end

      context 'and state is specified' do
        before { described_class.register_usa(regions: central_area_1_regions, state: 'New York', county: 'Broome') }
        let(:central_area_codes) { subject.keys }
        let(:central_area_code) { central_area_codes.first }
        let(:registration) { subject[central_area_code] }
        it 'includes USA, state, and county' do
          expect(central_area_code).to eq 'usa-new_york-broome'
          expect(registration).to be_kind_of CovidTracker::CentralAreaRegistration
          expect(registration.country_iso).to eq 'USA'
          expect(registration.province_state).to eq 'New York'
          expect(registration.admin2_county).to eq 'Broome'
        end
      end
    end
  end

  describe '.register' do
    context 'when regions is not specified' do
      it 'raises Argument error' do
        expect { described_class.register(country_iso: 'usa') }.to raise_error ArgumentError, 'regions is required'
      end
    end

    context 'when regions is specified' do
      context 'and country iso is not specified' do
        it 'raises argument error exception' do
          expect { described_class.register(regions: central_area_1_regions) }.to raise_error ArgumentError, 'missing keyword: country_iso'
        end
      end

      context 'and country iso is specified' do
        let(:central_area_codes) { subject.keys }
        let(:central_area_code) { central_area_codes.first }
        let(:registration) { subject[central_area_code] }
        context 'and admin2 is not specified' do
          context 'and province is not specified' do
            before { described_class.register(regions: central_area_1_regions, country_iso: 'CHN') }
            it 'only includes country iso' do
              expect(central_area_code).to eq 'chn'
              expect(registration).to be_kind_of CovidTracker::CentralAreaRegistration
              expect(registration.country_iso).to eq 'CHN'
              expect(registration.province_state).to be_nil
              expect(registration.admin2_county).to be_nil
            end
          end

          context 'and province is specified' do
            before { described_class.register(regions: central_area_1_regions, country_iso: 'DEU', province_state: 'Berlin') }
            let(:central_area_codes) { subject.keys }
            let(:central_area_code) { central_area_codes.first }
            let(:registration) { subject[central_area_code] }
            it 'includes USA and state' do
              expect(central_area_code).to eq 'deu-berlin'
              expect(registration).to be_kind_of CovidTracker::CentralAreaRegistration
              expect(registration.country_iso).to eq 'DEU'
              expect(registration.province_state).to eq 'Berlin'
              expect(registration.admin2_county).to be_nil
            end
          end
        end

        context 'and admin2 and province are specified' do
          before { described_class.register(regions: central_area_1_regions, country_iso: 'USA', province_state: 'Georgia', admin2_county: 'Columbia') }
          let(:central_area_codes) { subject.keys }
          let(:central_area_code) { central_area_codes.first }
          let(:registration) { subject[central_area_code] }
          it 'includes USA, state, and county' do
            expect(central_area_code).to eq 'usa-georgia-columbia'
            expect(registration).to be_kind_of CovidTracker::CentralAreaRegistration
            expect(registration.country_iso).to eq 'USA'
            expect(registration.province_state).to eq 'Georgia'
            expect(registration.admin2_county).to eq 'Columbia'
          end
        end
      end
    end

    # NOTE: This looks like it is checking registering the same area with multiple regions, but it is actually calling
    #       central_area_registry multiple times with the same regions, which is ok, but uncommon.  It does test the
    #       desired functionality of registering multiple areas.
    context 'when called multiple times' do
      before do
        described_class.register(regions: central_area_1_regions, country_iso: 'ALB')
        described_class.register(regions: central_area_1_regions, country_iso: 'AUS', province_state: 'Victoria')
        described_class.register(regions: central_area_1_regions, country_iso: 'USA', province_state: 'Colorado', admin2_county: 'Broomfield')
      end

      it 'has a registration for each country registered' do
        countries = subject.values.map(&:country_iso)
        expect(countries).to contain_exactly('USA', 'AUS', 'ALB')
      end

      it 'registers multiple regions' do # rubocop:disable RSpec/ExampleLength
        subject.each_value do |registration|
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

  describe '.find_by' do
    before do
      described_class.register(regions: central_area_1_regions, country_iso: 'ALB')
      described_class.register(regions: central_area_1_regions, country_iso: 'AUS', province_state: 'Victoria')
      described_class.register(regions: central_area_1_regions, country_iso: 'USA', province_state: 'Colorado', admin2_county: 'Broomfield')
    end
    let(:registration) { described_class.find_by(code: 'aus-victoria') }
    it 'finds registration given the central area code' do
      expect(registration.country_iso).to eq 'AUS'
      expect(registration.province_state).to eq 'Victoria'
      expect(registration.admin2_county).to be_nil
    end
  end

  describe '.areas' do
    before do
      described_class.register(regions: central_area_1_regions, country_iso: 'ALB')
      described_class.register(regions: central_area_1_regions, country_iso: 'AUS', province_state: 'Victoria')
      described_class.register(regions: central_area_1_regions, country_iso: 'USA', province_state: 'Colorado', admin2_county: 'Broomfield')
    end
    let(:registrations) { described_class.areas }
    it 'finds registration given the central area code' do
      expect(registrations).to be_kind_of Array
      expect(registrations.count).to eq 3
      expect(registrations.first).to be_kind_of CovidTracker::CentralAreaRegistration
      expect(registrations.map(&:country_iso)).to match_array ['ALB', 'AUS', 'USA']
    end
  end
end
