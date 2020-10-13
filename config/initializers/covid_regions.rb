# frozen_string_literal: true

# Registering regions in a central area
CovidTracker::CentralAreaRegistry.register_usa(state: 'New York', county: 'Cortland',
                                               tab_label: "Cortland County, NY",
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
