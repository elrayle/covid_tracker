# frozen_string_literal: true

# This module sets up the keys used to access top level sections created by the covid_tracker authority
module CovidTracker
  module RegionKeys
    REGION_LABEL = :region_label
    REGION_DATA = :region_data
  end
end

# This module sets up the keys used to access result data created by the covid_tracker authority
module CovidTracker
  module ResultKeys
    RESULT_SECTION = :result

    ERROR = :error

    RESULT_CODE = :result_code
    RESULT_LABEL = :result_label
    REGION_CODE = :region_code
    REGION_LABEL = :region_label
    DATE = :date
    CUMULATIVE_CONFIRMED = :cumulative_confirmed
    DELTA_CONFIRMED = :delta_confirmed
    CUMULATIVE_DEATHS = :cumulative_deaths
    DELTA_DEATHS = :delta_deaths
    CUMULATIVE_7_DAYS_CONFIRMED = :cumulative_7_days_confirmed
  end
end

# This module sets up the keys used to access request data created by the covid_tracker authority
module CovidTracker
  module RequestKeys
    REQUEST_SECTION = :request

    DATE = :date
    COUNTRY_ISO = :country_iso
    PROVINCE_STATE = :province_state
    ADMIN2_COUNTY = :admin2_county
  end
end
