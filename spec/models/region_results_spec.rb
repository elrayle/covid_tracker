# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::RegionResults do
  describe '.new' do
    include_context "shared raw results"
    let(:registration) { CovidTracker::RegionRegistration.new(country_iso: 'USA', province_state: 'New York', admin2_county: 'Broome') }
    let(:region_data) { [CovidTracker::RegionDatum.for(raw_datum_without_error), CovidTracker::RegionDatum.for(raw_datum_2)] }
    let(:region_results) { described_class.new(region_registration: registration, region_data: region_data) }

    it 'creates an instance with the values set' do # rubocop:disable RSpec/ExampleLength
      expect(region_results.region_registration).to be_kind_of CovidTracker::RegionRegistration
      expect(region_results.region_label).to eq 'Broome, New York, USA'
      expect(region_results.region_code).to eq 'usa-new_york-broome'
      expect(region_results.region_data).to be_kind_of Array
      expect(region_results.region_data.first).to be_kind_of CovidTracker::RegionDatum
      expect(region_results.region_data.size).to eq 2
    end
  end
end
