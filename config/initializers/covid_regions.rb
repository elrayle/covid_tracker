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
