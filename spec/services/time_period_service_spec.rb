# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CovidTracker::TimePeriodService do
  describe '.text_form' do
    it 'returns appropriate string for the time period' do
      expect(described_class.text_form(described_class::THIS_WEEK)).to eq "This Week"
      expect(described_class.text_form(described_class::THIS_MONTH)).to eq "This Month"
      expect(described_class.text_form(described_class::SINCE_MARCH)).to eq "Since March"
    end
  end

  describe '.long_form' do
    it 'returns appropriate long form for the time period' do
      expect(described_class.long_form(described_class::THIS_WEEK)).to eq "this_week"
      expect(described_class.long_form(described_class::THIS_MONTH)).to eq "this_month"
      expect(described_class.long_form(described_class::SINCE_MARCH)).to eq "since_march"
    end
  end

  describe '.short_form' do
    it 'returns appropriate short form for the time period' do
      expect(described_class.short_form(described_class::THIS_WEEK)).to eq "7_days"
      expect(described_class.short_form(described_class::THIS_MONTH)).to eq "30_days"
      expect(described_class.short_form(described_class::SINCE_MARCH)).to eq "since_march"
    end
  end

  describe '.days' do
    before do
      march01 = DateTime.strptime("03-01-2020 22:00:00 Eastern Time (US & Canada)", '%m-%d-%Y %H:%M:%S %Z')
      stub_now_dt = march01 + 181.days
      allow(DateTime).to receive_message_chain(:now, :in_time_zone).with("Eastern Time (US & Canada)").and_return(stub_now_dt) # rubocop:disable RSpec/MessageChain
    end

    it 'returns appropriate count of days for the time period' do
      expect(described_class.days(described_class::THIS_WEEK)).to eq 7
      expect(described_class.days(described_class::THIS_MONTH)).to eq 30
      expect(described_class.days(described_class::SINCE_MARCH)).to eq 180
    end
  end

  describe '.today_str' do
    before do
      stub_now_dt = DateTime.strptime("08-30-2020 12:00:00 Eastern Time (US & Canada)", '%m-%d-%Y %H:%M:%S %Z')
      allow(DateTime).to receive_message_chain(:now, :in_time_zone).with("Eastern Time (US & Canada)").and_return(stub_now_dt) # rubocop:disable RSpec/MessageChain
    end

    it "returns today's date formatted for Jekyll Last Updated page date" do
      expect(described_class.today_str).to eq "Aug 30, 2020"
    end
  end

  describe '.date_to_label' do
    it "returns the passed in date in the format MMM-DD which is used for graph column labels" do
      expect(described_class.date_to_label("2020-03-22")).to eq "Mar-22"
    end
  end

  describe '.str_date_from_idx' do
    it "returns a string date that is 2 days earlier than the passed in date" do
      expect(described_class.str_date_from_idx("2020-03-22", 2)).to eq "2020-03-20"
    end
  end

  describe '.str_to_date' do
    it "returns today's date formatted for Jekyll Last Updated page date" do
      expected_date = DateTime.strptime("03-22-2020 12:00:00 Eastern Time (US & Canada)", '%m-%d-%Y %H:%M:%S %Z').to_date
      expect(described_class.str_to_date("2020-03-22")).to eq expected_date
    end
  end

  describe '.date_to_str' do
    let(:date) { DateTime.strptime("08-30-2020 12:00:00 Eastern Time (US & Canada)", '%m-%d-%Y %H:%M:%S %Z') }

    it "returns today's date formatted for Jekyll Last Updated page date" do
      expect(described_class.date_to_str(date)).to eq "2020-08-30"
    end
  end

  describe '.days_in_range' do
    let(:oldest_date) { "2020-03-01" }
    let(:newest_date) { "2020-03-10" }

    it "returns count of days between two dates" do
      expect(described_class.days_in_range(oldest_date: oldest_date, newest_date: newest_date)).to eq 10
    end
  end
end
