# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::RegionRegistry do
  after { described_class.clear_registry }

  subject { described_class.registry }
  describe '.register_usa' do
    context 'when county is not specified' do
      context 'and state is not specified' do
        before { described_class.register_usa }
        it 'only includes USA' do
          expect(subject).to include({ country_iso: 'USA' })
        end
      end

      context 'and state is specified' do
        before { described_class.register_usa(state: 'Virginia') }
        it 'includes USA and state' do
          expect(subject).to include({ country_iso: 'USA', province_state: 'Virginia' })
        end
      end
    end

    context 'when state and county are specified' do
      before { described_class.register_usa(state: 'New York', county: 'Broome') }
      it 'includes USA, state, and county' do
        expect(subject).to include({ country_iso: 'USA', province_state: 'New York', admin2_county: 'Broome' })
      end
    end
  end

  describe '.register' do
    context 'when country iso is specified' do
      context 'and admin2 is not specified' do
        context 'and province is not specified' do
          before { described_class.register(country_iso: 'CHN') }
          it 'only includes country iso' do
            expect(subject).to include({ country_iso: 'CHN' })
          end
        end

        context 'and province is specified' do
          before { described_class.register(country_iso: 'DEU', province_state: 'Berlin') }
          it 'includes USA and state' do
            expect(subject).to include({ country_iso: 'DEU', province_state: 'Berlin' })
          end
        end
      end

      context 'and admin2 and province are specified' do
        before { described_class.register(country_iso: 'USA', province_state: 'Georgia', admin2_county: 'Columbia') }
        it 'includes USA, state, and county' do
          expect(subject).to include({ country_iso: 'USA', province_state: 'Georgia', admin2_county: 'Columbia' })
        end
      end
    end

    context 'when country iso is not specified' do
      it 'raises argument error exception' do
        expect{ described_class.register }.to raise_error ArgumentError
      end
    end

    context 'when called multiple times' do
      before do
        described_class.register(country_iso: 'ALB')
        described_class.register(country_iso: 'AUS', province_state: 'Victoria')
        described_class.register(country_iso: 'USA', province_state: 'Colorado', admin2_county: 'Broomfield')
      end

      it 'registers multiple regions' do
        expect(subject).to include({ country_iso: 'ALB' })
        expect(subject).to include({ country_iso: 'AUS', province_state: 'Victoria' })
        expect(subject).to include({ country_iso: 'USA', province_state: 'Colorado', admin2_county: 'Broomfield' })
      end
    end
  end
end
