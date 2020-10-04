# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::RegionResults do
  describe '.new' do
    include_context "shared raw results in region 1"

    let(:region_results) do
      described_class.new(region_registration: region_registration_1,
                          region_data: region_1_data)
    end

    it 'creates an instance with the values set' do # rubocop:disable RSpec/ExampleLength
      expect(region_results.region_registration).to be_kind_of CovidTracker::RegionRegistration
      expect(region_results.region_label).to eq region_1_label
      expect(region_results.region_code).to eq region_1_code
      expect(region_results.region_data).to be_kind_of Array
      expect(region_results.region_data.first).to be_kind_of CovidTracker::RegionDatum
      expect(region_results.region_data.size).to eq 2
    end
  end
end
