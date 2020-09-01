require 'spec_helper'

describe Qa::Authorities::Covid do
  let(:authority) { described_class.new }

  let(:term_controller) { instance_double(Qa::TermsController) }

  describe "#build_query_url" do
    before do
      allow(term_controller).to receive(:params).and_return({ country_iso: 'USA' })
      allow(authority).to receive(:date).and_return('2020-05-31')
      allow(authority).to receive(:country_iso).and_return('USA')
      allow(authority).to receive(:province_state).and_return(nil)
      allow(authority).to receive(:admin2_county).and_return(nil)
    end

    subject { authority.build_query_url("foo") }
    it { is_expected.to eq "https://covid-api.com/api/reports?date=2020-05-31&iso=USA" }
  end

  describe "#find_url" do
    subject { authority.find_url("300053264") }
    it { is_expected.to eq "http://vocab.getty.edu/download/json?uri=http://vocab.getty.edu/aat/300053264.json" }
  end

  describe "#search" do
    context "authorities" do
      before do
        stub_request(:get, /vocab\.getty\.edu.*/)
            .to_return(body: webmock_fixture("aat-response.txt"), status: 200)
      end

      subject { authority.search('whatever') }

      it "has id and label keys" do
        expect(subject.first).to eq("id" => 'http://vocab.getty.edu/aat/300053264', "label" => "photocopying")
        expect(subject.last).to eq("id" => 'http://vocab.getty.edu/aat/300265560', "label" => "photoscreenprints")
        expect(subject.size).to eq(10)
      end

      context 'when Getty returns an error,' do
        before do
          stub_request(:get, /vocab\.getty\.edu.*/)
              .to_return(body: webmock_fixture("getty-error-response.txt"), status: 500)
        end

        it 'logs error and returns empty results' do
          expect(Rails.logger).to receive(:warn).with("  ERROR fetching Getty response: undefined method `[]' for nil:NilClass; cause: UNKNOWN")
          expect(subject).to be {}
        end
      end
    end
  end

  describe "#untaint" do
    subject { authority.untaint(value) }

    context "with a good string" do
      let(:value) { 'Water-color paint' }
      it { is_expected.to eq 'Water-color paint' }
    end

    context "bad stuff" do
      let(:value) { './"' }
      it { is_expected.to eq '' }
    end
  end

  describe "#find" do
    context "using a subject id" do
      before do
        stub_request(:get, "http://vocab.getty.edu/download/json?uri=http://vocab.getty.edu/aat/300265560.json")
            .to_return(status: 200, body: webmock_fixture("getty-aat-find-response.json"))
      end
      subject { authority.find("300265560") }

      it "returns the complete record for a given subject" do
        expect(subject['results']['bindings'].size).to eq 189
        expect(subject['results']['bindings']).to all(have_key('Subject'))
        expect(subject['results']['bindings']).to all(have_key('Predicate'))
        expect(subject['results']['bindings']).to all(have_key('Object'))
      end
    end
  end

  describe "#request_options" do
    subject { authority.request_options }
    it { is_expected.to eq(accept: "application/sparql-results+json") }
  end
  # rubocop:disable Layout/LineLength
  describe "#sparql" do
    context "using a single subject term" do
      subject { authority.sparql('search_term') }
      it {
        is_expected.to eq %(SELECT ?s ?name { ?s a skos:Concept; luc:term "search_term"; skos:inScheme <http://vocab.getty.edu/aat/> ; gvp:prefLabelGVP [skosxl:literalForm ?name]. FILTER regex(?name, "search_term", "i") . } ORDER BY ?name)
      }
    end
    context "using a two subject terms" do
      subject { authority.sparql('search term') }
      it {
        is_expected.to eq %(SELECT ?s ?name { ?s a skos:Concept; luc:term "search term"; skos:inScheme <http://vocab.getty.edu/aat/> ; gvp:prefLabelGVP [skosxl:literalForm ?name]. FILTER ((regex(?name, "search", "i")) && (regex(?name, "term", "i"))) . } ORDER BY ?name)
      }
    end
  end
  # rubocop:enable Layout/LineLength
end
