# frozen_string_literal: true

# This module sets up the keys used to access result data created by the covid_tracker authority
module CovidTracker
  module ResultKeys
    ID = :id
    REGION_ID = :region_id
    LABEL = :label
    DATE = :date
    CUMULATIVE_CONFIRMED = :cumulative_confirmed
    DELTA_CONFIRMED = :delta_confirmed
    CUMULATIVE_DEATHS = :cumulative_deaths
    DELTA_DEATHS = :delta_deaths
  end
end
