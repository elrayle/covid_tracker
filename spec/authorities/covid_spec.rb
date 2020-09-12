# frozen_string_literal: true

require 'spec_helper'

# URLs for testing in the browser
#   PASS: http://localhost:3000/api/search/covid?country_iso=USA
#   PASS: http://localhost:3000/api/search/covid?country_iso=USA&province_state=New%20York
#   PASS: http://localhost:3000/api/search/covid?country_iso=USA&province_state=New%20York&admin2_county=Cortland
#   PASS: http://localhost:3000/api/search/covid?province_state=New%20York
#   PASS: http://localhost:3000/api/search/covid?province_state=New%20York&admin2_county=Cortland
#   FAIL: http://localhost:3000/api/search/covid?country_iso=USA&admin2_county=Cortland
#   FAIL: http://localhost:3000/api/search/covid?admin2_county=Cortland
describe Qa::Authorities::Covid do
  let(:authority) { described_class.new }

  describe "#build_query_url" do
    context "when country is specified" do
      context "and no other params" do
        before do
          # need to set return values for instance variable since they aren't set by this method
          allow(authority).to receive(:date).and_return('2020-05-31')
          allow(authority).to receive(:country_iso).and_return('USA')
          allow(authority).to receive(:province_state).and_return(nil)
          allow(authority).to receive(:admin2_county).and_return(nil)
        end
        subject { authority.build_query_url }
        it { is_expected.to eq "https://covid-api.com/api/reports?date=2020-05-31&iso=USA" }
      end

      context "and state is specified" do
        context "and county is NOT specified" do
          before do
            # need to set return values for instance variable since they aren't set by this method
            allow(authority).to receive(:date).and_return('2020-05-31')
            allow(authority).to receive(:country_iso).and_return('USA')
            allow(authority).to receive(:province_state).and_return('Texas')
            allow(authority).to receive(:admin2_county).and_return(nil)
          end
          subject { authority.build_query_url }
          it { is_expected.to eq "https://covid-api.com/api/reports?date=2020-05-31&iso=USA&region_province=Texas" }
        end

        context "and county is specified" do
          before do
            # need to set return values for instance variable since they aren't set by this method
            allow(authority).to receive(:date).and_return('2020-05-31')
            allow(authority).to receive(:country_iso).and_return('USA')
            allow(authority).to receive(:province_state).and_return('Texas')
            allow(authority).to receive(:admin2_county).and_return('Clay')
          end
          subject { authority.build_query_url }
          it { is_expected.to eq "https://covid-api.com/api/reports?date=2020-05-31&iso=USA&region_province=Texas&city_name=Clay" }
        end
      end
    end
  end

  describe "#search" do
    let(:term_controller) { instance_double(Qa::TermsController) }
    let(:date) { '2020-05-31' }
    context "when country is specified" do
      context "and no other params" do
        let(:expected_request) do
          {
            date: date,
            country_iso: 'USA'
          }
        end
        let(:expected_result) do
          {
            id: "#{date}usa",
            label: "USA (#{date})",
            region_id: "usa",
            region_label: "USA",
            date: date,
            cumulative_confirmed: 50,
            delta_confirmed: 2708,
            cumulative_deaths: 7,
            delta_deaths: 88
          }
        end
        before do
          allow(term_controller).to receive(:params).and_return('country_iso' => 'USA')
          allow(authority).to receive(:date).and_return(date)
          stub_request(:get, "https://covid-api.com/api/reports?date=2020-05-31&iso=USA")
            .to_return(body: webmock_fixture("covid-api/country.json"), status: 200)
        end
        subject { authority.search('', term_controller) }

        it 'has expected request values' do
          expect(subject[:request]).to include expected_request
        end

        it 'has expected result' do
          # counts come from the values in the fixture
          expect(subject[:result]).to include expected_result
        end
      end

      context "and state is specified" do
        context "and county is NOT specified" do
          let(:expected_request) do
            {
              date: date,
              country_iso: 'USA',
              province_state: 'Iowa'
            }
          end
          let(:expected_result) do
            # counts come from the values in the fixture
            {
              id: "#{date}usa-iowa",
              label: "Iowa, USA (#{date})",
              region_id: "usa-iowa",
              region_label: "Iowa, USA",
              date: date,
              cumulative_confirmed: 43,
              delta_confirmed: 540,
              cumulative_deaths: 6,
              delta_deaths: 7
            }
          end
          before do
            allow(term_controller).to receive(:params).and_return('country_iso' => 'USA', 'province_state' => 'Iowa')
            allow(authority).to receive(:date).and_return(date)
            stub_request(:get, "https://covid-api.com/api/reports?date=2020-05-31&iso=USA&region_province=Iowa")
              .to_return(body: webmock_fixture("covid-api/country_state.json"), status: 200)
          end
          subject { authority.search('', term_controller) }

          it 'has expected request and result' do
            expect(subject[:request]).to include expected_request
            expect(subject[:result]).to include expected_result
          end
        end

        context "and county is specified" do
          let(:expected_request) do
            {
              date: date,
              country_iso: 'USA',
              province_state: 'Texas',
              admin2_county: 'Denton'
            }
          end
          let(:expected_result) do
            # counts come from the values in the fixture
            {
              id: "#{date}usa-texas-denton",
              label: "Denton, Texas, USA (#{date})",
              region_id: "usa-texas-denton",
              region_label: "Denton, Texas, USA",
              date: date,
              cumulative_confirmed: 10,
              delta_confirmed: 447,
              cumulative_deaths: 3,
              delta_deaths: 6
            }
          end
          before do
            allow(term_controller).to receive(:params).and_return('country_iso' => 'USA', 'province_state' => 'Texas', 'admin2_county' => 'Denton')
            allow(authority).to receive(:date).and_return(date)
            stub_request(:get, "https://covid-api.com/api/reports?date=2020-05-31&iso=USA&region_province=Texas&city_name=Denton")
              .to_return(body: webmock_fixture("covid-api/country_state_county.json"), status: 200)
          end
          subject { authority.search('', term_controller) }

          it 'has expected request and result' do
            expect(subject[:request]).to include expected_request
            expect(subject[:result]).to include expected_result
          end
        end
      end
    end
  end

  # rubocop:enable Layout/LineLength
end
