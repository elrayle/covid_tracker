RSpec.shared_context "shared central area registration 1", shared_context: :metadata do
  include_context "shared region registration 1"
  include_context "shared region registration 2"

  let(:country_iso_label_central_area_1) { country_iso_label_region_1 }
  let(:province_state_label_central_area_1) { province_state_label_region_1 }
  let(:admin2_county_label_central_area_1) { admin2_county_label_region_1 }

  let(:central_area_1_region_1) { region_registration_1 }
  let(:central_area_1_region_2) { region_registration_2 }
  let(:central_area_1_regions) { [central_area_1_region_1, central_area_1_region_2] }

  let(:central_area_1_tab_label) { "tab: #{region_registration_1.label}" }
  let(:central_area_1_homepage_title) { "hpt: #{region_registration_1.label}" }

  let(:central_area_1_code) { region_1_code }
  let(:central_area_1_label) { region_1_label }

  let(:central_area_registration_1) do
    CovidTracker::CentralAreaRegistration.new(country_iso: country_iso_label_central_area_1,
                                              province_state: province_state_label_central_area_1,
                                              admin2_county: admin2_county_label_central_area_1,
                                              regions: central_area_1_regions,
                                              tab_label: central_area_1_tab_label,
                                              homepage_title: central_area_1_homepage_title)
  end
end
