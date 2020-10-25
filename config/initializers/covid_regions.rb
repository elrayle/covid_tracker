# frozen_string_literal: true

# Registering regions in a central area
CovidTracker::CentralAreaRegistry.register_usa(state: 'New York', county: 'Cortland',
                                               sidebar_label: "Cortland County, NY Area",
                                               homepage_title: "Cortland County, NY and Surrounding Counties") do
  [
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Cortland'),
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Tompkins'),
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Broome'),
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Onondaga'),
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Cayuga'),
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Madison'),
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Chenango'),
    CovidTracker::RegionRegistration.for_usa(state: 'New York', county: 'Tioga')
  ]
end

CovidTracker::CentralAreaRegistry.register_usa(state: 'Georgia', county: 'Columbia',
                                               sidebar_label: "Augusta, GA Metro Area",
                                               homepage_title: "Augusta, GA Metro Area") do
  [
    CovidTracker::RegionRegistration.for_usa(state: 'Georgia', county: 'Columbia'),
    CovidTracker::RegionRegistration.for_usa(state: 'Georgia', county: 'Richmond'),
    CovidTracker::RegionRegistration.for_usa(state: 'Georgia', county: 'Burke'),
    CovidTracker::RegionRegistration.for_usa(state: 'Georgia', county: 'Lincoln'),
    CovidTracker::RegionRegistration.for_usa(state: 'Georgia', county: 'McDuffie'),
    CovidTracker::RegionRegistration.for_usa(state: 'South Carolina', county: 'Aiken'),
    CovidTracker::RegionRegistration.for_usa(state: 'South Carolina', county: 'Edgefield'),
    CovidTracker::RegionRegistration.for_usa(state: 'South Carolina', county: 'McCormick')
  ]
end

CovidTracker::CentralAreaRegistry.register_usa(state: 'Missouri', county: 'Cole',
                                               sidebar_label: "Cole County, MO Area",
                                               homepage_title: "Jefferson City, MO and Surrounding Counties") do
  [
    CovidTracker::RegionRegistration.for_usa(state: 'Missouri', county: 'Cole'),
    CovidTracker::RegionRegistration.for_usa(state: 'Missouri', county: 'Boone'),
    CovidTracker::RegionRegistration.for_usa(state: 'Missouri', county: 'Callaway'),
    CovidTracker::RegionRegistration.for_usa(state: 'Missouri', county: 'Osage'),
    CovidTracker::RegionRegistration.for_usa(state: 'Missouri', county: 'Miller'),
    CovidTracker::RegionRegistration.for_usa(state: 'Missouri', county: 'Moniteau')
  ]
end

CovidTracker::CentralAreaRegistry.register_usa(state: 'Texas', county: 'Brazos',
                                               sidebar_label: "Bryan, TX Area",
                                               homepage_title: "Bryan, TX and Surrounding Counties") do
  [
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'Brazos'),
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'Robertson'),
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'Leon'),
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'Madison'),
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'Grimes'),
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'Washington'),
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'Burleson'),
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'Milam')
  ]
end

CovidTracker::CentralAreaRegistry.register_usa(state: 'Texas', county: 'Montgomery',
                                               sidebar_label: "Conroe, TX Area",
                                               homepage_title: "Conroe, TX and Surrounding Counties") do
  [
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'Montgomery'),
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'Walker'),
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'San Jacinto'),
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'Liberty'),
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'Harris'),
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'Waller'),
    CovidTracker::RegionRegistration.for_usa(state: 'Texas', county: 'Grimes')
  ]
end

CovidTracker::CentralAreaRegistry.register_usa(state: 'Ohio', county: 'Butler',
                                               sidebar_label: "Oxford, TX Area",
                                               homepage_title: "Oxford, TX and Surrounding Counties") do
  [
    CovidTracker::RegionRegistration.for_usa(state: 'Ohio', county: 'Butler'),
    CovidTracker::RegionRegistration.for_usa(state: 'Ohio', county: 'Preble'),
    CovidTracker::RegionRegistration.for_usa(state: 'Ohio', county: 'Montgomery'),
    CovidTracker::RegionRegistration.for_usa(state: 'Ohio', county: 'Warren'),
    CovidTracker::RegionRegistration.for_usa(state: 'Ohio', county: 'Hamilton'),
    CovidTracker::RegionRegistration.for_usa(state: 'Indiana', county: 'Dearborn'),
    CovidTracker::RegionRegistration.for_usa(state: 'Indiana', county: 'Franklin'),
    CovidTracker::RegionRegistration.for_usa(state: 'Indiana', county: 'Union')
  ]
end

CovidTracker::CentralAreaRegistry.register_usa(state: 'Florida', county: 'Sarasota',
                                               sidebar_label: "Sarasota, FL Area",
                                               homepage_title: "Sarasota, FL and Surrounding Counties") do
  [
    CovidTracker::RegionRegistration.for_usa(state: 'Florida', county: 'Sarasota'),
    CovidTracker::RegionRegistration.for_usa(state: 'Florida', county: 'Manatee')
  ]
end
