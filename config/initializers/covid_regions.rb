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
