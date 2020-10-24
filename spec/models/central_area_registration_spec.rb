# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::CentralAreaRegistration do
  include_context "shared central area registration 1"

  describe 'attr_readers' do
    let(:subject) do
      described_class.new(country_iso: country_iso_label_central_area_1,
                          province_state: province_state_label_central_area_1,
                          admin2_county: admin2_county_label_central_area_1,
                          regions: central_area_1_regions,
                          sidebar_label: central_area_1_sidebar_label,
                          homepage_title: central_area_1_homepage_title)
    end

    it { is_expected.to respond_to(:code) }
    it { is_expected.to respond_to(:label) }
    it { is_expected.to respond_to(:country_iso) }
    it { is_expected.to respond_to(:province_state) }
    it { is_expected.to respond_to(:admin2_county) }
    it { is_expected.to respond_to(:regions) }
    it { is_expected.to respond_to(:sidebar_label) }
    it { is_expected.to respond_to(:homepage_title) }
  end

  describe '.new' do
    context 'when regions is not specified' do
      it 'raises Argument error' do
        expect { described_class.new }.to raise_error ArgumentError, 'regions is required'
      end
    end

    context 'when regions is specified' do
      context 'and country is not specified' do
        it 'raises Argument error' do
          expect { described_class.new(regions: central_area_1_regions) }
            .to raise_error ArgumentError, 'country_iso is required'
        end
      end

      context 'and country is specified' do
        context 'and state is not specified' do
          context 'and county is specified' do
            it 'raises Argument error' do
              expect { described_class.new(regions: central_area_1_regions, country_iso: 'USA', admin2_county: 'Richmond') }
                .to raise_error ArgumentError, 'province_state must be defined to include admin2_county'
            end
          end
        end
      end
    end
  end

  describe '#code' do
    context 'when county is not specified' do
      context 'and state is not specified' do
        let(:registration) { described_class.new(regions: central_area_1_regions, country_iso: 'USA') }
        it 'only includes USA' do
          expect(registration.code).to eq 'usa'
        end
      end

      context 'and state is specified' do
        let(:registration) { described_class.new(regions: central_area_1_regions, country_iso: 'USA', province_state: 'Virginia') }
        it 'includes USA and state' do
          expect(registration.code).to eq 'usa-virginia'
        end
      end
    end

    context 'when state and county are specified' do
      let(:registration) { described_class.new(regions: central_area_1_regions, country_iso: 'USA', province_state: 'New York', admin2_county: 'Broome') }
      it 'includes USA, state, and county' do
        expect(registration.code).to eq 'usa-new_york-broome'
      end
    end
  end

  describe '#label' do
    context 'when county is not specified' do
      context 'and state is not specified' do
        let(:registration) { described_class.new(regions: central_area_1_regions, country_iso: 'USA') }
        it 'only includes USA' do
          expect(registration.label).to eq 'USA'
        end
      end

      context 'and state is specified' do
        let(:registration) { described_class.new(regions: central_area_1_regions, country_iso: 'USA', province_state: 'Virginia') }
        it 'includes USA and state' do
          expect(registration.label).to eq 'Virginia, USA'
        end
      end
    end

    context 'when state and county are specified' do
      let(:registration) { described_class.new(regions: central_area_1_regions, country_iso: 'USA', province_state: 'New York', admin2_county: 'Broome') }
      it 'includes USA, state, and county' do
        expect(registration.label).to eq 'Broome, New York, USA'
      end
    end
  end

  describe '#sidebar_label' do
    context 'when not specified' do
      let(:registration) { described_class.new(regions: central_area_1_regions, country_iso: 'USA', province_state: 'New York', admin2_county: 'Broome') }
      it "defaults to central area's label" do
        expect(registration.sidebar_label).to eq 'Broome, New York, USA'
      end
    end

    context 'when specified' do
      let(:custom_sidebar_label) { 'Custom Tab Label' }
      let(:registration) do
        described_class.new(regions: central_area_1_regions, country_iso: 'USA', province_state: 'New York',
                            admin2_county: 'Broome', sidebar_label: custom_sidebar_label)
      end
      it "returns passed in tab label" do
        expect(registration.sidebar_label).to eq custom_sidebar_label
      end
    end
  end

  describe '#homepage_title' do
    context 'when not specified' do
      let(:registration) { described_class.new(regions: central_area_1_regions, country_iso: 'USA', province_state: 'New York', admin2_county: 'Broome') }
      it "defaults to central area's label" do
        expect(registration.homepage_title).to eq 'Broome, New York, USA'
      end
    end

    context 'when specified' do
      let(:custom_homepage_title) { 'Custom Homepage Title' }
      let(:registration) do
        described_class.new(regions: central_area_1_regions, country_iso: 'USA', province_state: 'New York',
                            admin2_county: 'Broome', homepage_title: custom_homepage_title)
      end
      it "returns passed in homepage title" do
        expect(registration.homepage_title).to eq custom_homepage_title
      end
    end
  end
end
