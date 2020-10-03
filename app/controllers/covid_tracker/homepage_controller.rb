# frozen_string_literal: true

require 'covid_tracker/keys'

# Controller for Monitor Status header menu item
module CovidTracker
  class HomepageController < ApplicationController
    layout 'covid_tracker/covid_tracker'

    DEFAULT_DAYS_TO_TRACK = CovidTracker::DataService::DEFAULT_DAYS_TO_TRACK

    class_attribute :presenter_class, :data_service_class
    self.presenter_class = CovidTracker::HomepagePresenter
    self.data_service_class = CovidTracker::DataService

    # Sets up presenter with data to display in the UI
    def index
      all_regions_data = data_service_class.all_regions_data(days: days_to_track)
      @presenter = presenter_class.new(all_regions_data: all_regions_data)
    end

  private

    def days_to_track
      (params[:days] || DEFAULT_DAYS_TO_TRACK).to_i
    end
  end
end
