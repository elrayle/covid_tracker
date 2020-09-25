# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::Region do
  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:region_code) }

  describe 'find_or_create_region_code_for' do
    let!(:region) { FactoryBot.create(:region, id: existing_region_id, region_code: existing_region_code) }
    let(:existing_region_code) { 'usa-new_york-cortland' }
    let(:existing_region_id) { 1 }
    context 'when code exists' do
      it 'returns the id' do
        expect(described_class.find_or_create_region_code_for(region_code: existing_region_code)).to eq existing_region_id
      end
    end

    context 'when code does not exist' do
      let(:non_existent_region_code) { 'usa-colorado-broomfield' }
      let(:new_region_id) { 2 }
      it 'creates a record for the code and returns the id' do
        expect(described_class.find_or_create_region_code_for(region_code: non_existent_region_code)).to eq new_region_id
      end
    end
  end
end
