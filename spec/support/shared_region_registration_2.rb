RSpec.shared_context "shared region registration 2", shared_context: :metadata do
  let(:country_iso_label_region_2) { 'USA' }
  let(:province_state_label_region_2) { 'Alabama' }
  let(:admin2_county_label_region_2) { 'Wilcox' }

  let(:country_iso_code_region_2) { country_iso_label_region_2.downcase }
  let(:province_state_code_region_2) { province_state_label_region_2.downcase }
  let(:admin2_county_code_region_2) { admin2_county_label_region_2.downcase }

  let(:region_2_label) { region_registration_2.label }
  let(:region_2_code) { region_registration_2.code }

  let(:region_registration_2) do
    CovidTracker::RegionRegistration.new(country_iso: country_iso_label_region_2,
                                         province_state: province_state_label_region_2,
                                         admin2_county: admin2_county_label_region_2)
  end
end
