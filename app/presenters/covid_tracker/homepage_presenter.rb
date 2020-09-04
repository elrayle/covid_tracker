# frozen_string_literal: true

# This presenter class provides all data needed by the view that monitors status of authorities.
module CovidTracker
  class HomepagePresenter
    # extend Forwardable

    attr_reader :all_results

    # @param all_results [Hash] results for all registered regions
    def initialize(all_results:)
      @all_results = all_results
    end
  end
end
