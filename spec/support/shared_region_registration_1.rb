RSpec.shared_context "shared region registration 1", shared_context: :metadata do
  let(:country_iso_label_region_1) { 'USA' }
  let(:province_state_label_region_1) { 'Alabama' }
  let(:admin2_county_label_region_1) { 'Butler' }

  let(:country_iso_code_region_1) { country_iso_label_region_1.downcase }
  let(:province_state_code_region_1) { province_state_label_region_1.downcase }
  let(:admin2_county_code_region_1) { admin2_county_label_region_1.downcase }

  let(:region_1_label) { region_registration_1.label }
  let(:region_1_code) { region_registration_1.code }

  let(:region_registration_1) do
    CovidTracker::RegionRegistration.new(country_iso: country_iso_label_region_1,
                                         province_state: province_state_label_region_1,
                                         admin2_county: admin2_county_label_region_1)
  end
end
