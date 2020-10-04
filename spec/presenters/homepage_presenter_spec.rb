# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::HomepagePresenter do
  include_context "shared raw results for 2 regions"

  let(:datum) { datum_for_region_1_day_1 }

  # TODO: Test delegated methods
  # delegate :result, :date, :cumulative_confirmed, :cumulative_deaths, :region_label, :region_code, :region_data, to: data_service

  subject { described_class.new(all_regions_data: raw_results_for_2_regions) }

  describe '#row_class' do
    context 'when row is even' do
      it 'returns css for even row' do
        expect(subject.row_class(2)).to eq "pure-table-even"
      end
    end

    context 'when row is odd' do
      it 'returns css for odd row' do
        expect(subject.row_class(1)).to eq "pure-table-odd"
      end
    end
  end

  describe '#date_class' do
    it 'returns neutral css class' do
      expect(subject.date_class(datum)).to eq "neutral"
    end
  end

  describe '#cumulative_confirmed_class' do
    it 'returns neutral css class' do
      expect(subject.cumulative_confirmed_class(datum)).to eq "neutral"
    end
  end

  describe '#delta_confirmed' do
    context 'when value is 0' do
      before { allow(CovidTracker::DataService).to receive(:delta_confirmed).with(datum).and_return(0) }
      it 'returns dash' do
        expect(subject.delta_confirmed(datum)).to eq "-"
      end
    end

    context 'when value is not 0' do
      before { allow(CovidTracker::DataService).to receive(:delta_confirmed).with(datum).and_return(3) }
      it 'returns the value' do
        expect(subject.delta_confirmed(datum)).to eq 3
      end
    end
  end

  describe '#delta_confirmed_class' do
    context 'when value is greater than critical_threshold' do
      before { allow(CovidTracker::DataService).to receive(:delta_confirmed).with(datum).and_return(11) }
      it 'returns the critical css class' do
        expect(subject.delta_confirmed_class(datum)).to eq 'critical'
      end
    end

    context 'when value is greater than moderate_threshold and less than critical_threshold' do
      before { allow(CovidTracker::DataService).to receive(:delta_confirmed).with(datum).and_return(7) }
      it 'returns the moderate css class' do
        expect(subject.delta_confirmed_class(datum)).to eq 'moderate'
      end
    end

    context 'when value is greater than low_threshold and less than moderate_threshold' do
      before { allow(CovidTracker::DataService).to receive(:delta_confirmed).with(datum).and_return(3) }
      it 'returns the low css class' do
        expect(subject.delta_confirmed_class(datum)).to eq 'low'
      end
    end

    context 'when value is less than low_threshold' do
      before { allow(CovidTracker::DataService).to receive(:delta_confirmed).with(datum).and_return(0) }
      it 'returns the neutral css class' do
        expect(subject.delta_confirmed_class(datum)).to eq 'neutral'
      end
    end
  end

  describe '#cumulative_deaths_class' do
    it 'returns neutral css class' do
      expect(subject.cumulative_deaths_class(datum)).to eq "neutral"
    end
  end

  describe '#delta_deaths' do
    context 'when value is 0' do
      before { allow(CovidTracker::DataService).to receive(:delta_deaths).with(datum).and_return(0) }
      it 'returns dash' do
        expect(subject.delta_deaths(datum)).to eq "-"
      end
    end

    context 'when value is not 0' do
      before { allow(CovidTracker::DataService).to receive(:delta_deaths).with(datum).and_return(2) }
      it 'returns the value' do
        expect(subject.delta_deaths(datum)).to eq 2
      end
    end
  end

  # @param datum [CovidTracker::RegionDatum] result and request info for a region on a date
  # @returns [String] css for table cell
  describe '#delta_deaths_class' do
    context 'when value is greater than critical_threshold' do
      before { allow(CovidTracker::DataService).to receive(:delta_deaths).with(datum).and_return(11) }
      it 'returns the critical css class' do
        expect(subject.delta_deaths_class(datum)).to eq 'critical'
      end
    end

    context 'when value is greater than moderate_threshold and less than critical_threshold' do
      before { allow(CovidTracker::DataService).to receive(:delta_deaths).with(datum).and_return(7) }
      it 'returns the moderate css class' do
        expect(subject.delta_deaths_class(datum)).to eq 'moderate'
      end
    end

    context 'when value is greater than low_threshold and less than moderate_threshold' do
      before { allow(CovidTracker::DataService).to receive(:delta_deaths).with(datum).and_return(3) }
      it 'returns the low css class' do
        expect(subject.delta_deaths_class(datum)).to eq 'low'
      end
    end

    context 'when value is less than low_threshold' do
      before { allow(CovidTracker::DataService).to receive(:delta_deaths).with(datum).and_return(0) }
      it 'returns the neutral css class' do
        expect(subject.delta_deaths_class(datum)).to eq 'neutral'
      end
    end
  end
end
