# frozen_string_literal: true

require 'covid_tracker/keys'

# Controller for Monitor Status header menu item
module CovidTracker
  class HomepageController < ApplicationController
    layout 'covid_tracker/covid_tracker'

    DEFAULT_DAYS_TO_TRACK = CovidTracker::DataRetrievalService::DEFAULT_DAYS_TO_TRACK
    DEFAULT_AREA = "usa-new_york-cortland"

    class_attribute :presenter_class, :data_retrieval_service, :area_registry_class
    self.presenter_class = CovidTracker::HomepagePresenter
    self.data_retrieval_service = CovidTracker::DataRetrievalService
    self.area_registry_class = CovidTracker::CentralAreaRegistry

    # Sets up presenter with data to display in the UI
    def index
      region_registration = area_registry_class.find_by(code: area)
      region_results = data_retrieval_service.region_results(region_registration: region_registration, days: days_to_track)
      @presenter = presenter_class.new(region_results: { area => region_results } )
    end

  private

    def days_to_track
      (params[:days] || DEFAULT_DAYS_TO_TRACK).to_i
    end

    def area
      params[:area] || DEFAULT_AREA
    end
  end
end
