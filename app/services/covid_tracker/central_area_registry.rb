# frozen_string_literal: true

module CovidTracker
  ##
  # This registry determines the central location grouping multiple region locations being tracked.
  #
  # For organizational purposes and to make the generated code easier to understand, the convention is to use the same
  # encoding used for regions to identify the region that is the center of the group of regions.  Directories and files
  # will be assigned names matching the region code for the region representing the central area (e.g. 'usa-alabama-wilcox_sidebar.html')
  #
  # @see CovidTracker::RegionRegistration for more information on the structure and creation of region codes
  #
  class CentralAreaRegistry
    include Singleton

    # @param state [String] US state for the region at the center of this group of regions
    # @param county [String] US county for the region at the center of this group of regions
    # @param regions [Array<CovidTracker::Region>] the central area region and regions surrounding the central area
    # @param sidebar_label [String] shorter label to display in above sidebar menu (defaults to central area's region label)
    # @param homepage_title [String] title to display on the homepage for this central area (defaults to central area's region label)
    def self.register_usa(state: nil, county: nil, regions: nil, sidebar_label: "", homepage_title: "")
      regions ||= yield if block_given?
      raise ArgumentError, "regions is required" if regions.blank?
      instance.register_usa(state: state, county: county, regions: regions,
                            sidebar_label: sidebar_label, homepage_title: homepage_title)
    end

    # @param country_iso [String] country iso for the region at the center of this group of regions
    # @param province_state [String] province or US state for the region at the center of this group of regions
    # @param admin2_county [String] admin2 level or US county for the region at the center of this group of regions
    # @param regions [Array<CovidTracker::Region>] the central area region and regions surrounding the central area
    # @param sidebar_label [String] shorter label to display in above sidebar menu (defaults to central area's region label)
    # @param homepage_title [String] title to display on the homepage for this central area (defaults to central area's region label)
    def self.register(country_iso:, province_state: nil, admin2_county: nil, # rubocop:disable Metrics/ParameterLists
                      regions: nil, sidebar_label: nil, homepage_title: nil)
      regions ||= yield if block_given?
      raise ArgumentError, "regions is required" if regions.blank?
      instance.register(country_iso: country_iso, province_state: province_state,
                        admin2_county: admin2_county, regions: regions,
                        sidebar_label: sidebar_label, homepage_title: homepage_title)
    end

    # @returns [Hash<String,CovidTracker::CentralAreaRegistration>] all registered central areas as code=area_registration
    def self.registry
      instance.registry
    end

    # empty the registry
    def self.clear_registry
      instance.clear_registry
    end

    # @param code [String] region code for the registered central region
    # @returns [CovidTracker::CentralAreaRegistration] the central area registration for the region represented by the code
    def self.find_by(code:)
      registry[code]
    end

    # @returns [Array<CovidTracker::CentralAreaRegistration>] all registered central areas
    def self.areas
      registry.values
    end

    def initialize
      @central_areas = {}
    end

    # @param state [String] US state for the region at the center of this group of regions
    # @param county [String] US county for the region at the center of this group of regions
    # @param regions [Array<CovidTracker::Region>] the central area region and regions surrounding the central area
    # @param sidebar_label [String] shorter label to display in above sidebar menu (defaults to central area's region label)
    # @param homepage_title [String] title to display on the homepage for this central area (defaults to central area's region label)
    def register_usa(state: nil, county: nil, regions:, sidebar_label: nil, homepage_title: nil)
      register(country_iso: 'USA', province_state: state, admin2_county: county, regions: regions,
               sidebar_label: sidebar_label, homepage_title: homepage_title)
    end

    # @param country_iso [String] country iso for the region at the center of this group of regions
    # @param province_state [String] province or US state for the region at the center of this group of regions
    # @param admin2_county [String] admin2 level or US county for the region at the center of this group of regions
    # @param regions [Array<CovidTracker::Region>] the central area region and regions surrounding the central area
    # @param sidebar_label [String] shorter label to display in above sidebar menu (defaults to central area's region label)
    # @param homepage_title [String] title to display on the homepage for this central area (defaults to central area's region label)
    def register(country_iso:, province_state: nil, admin2_county: nil, # rubocop:disable Metrics/ParameterLists
                 regions:, sidebar_label: nil, homepage_title: nil)
      central_area = CovidTracker::CentralAreaRegistration.new(country_iso: country_iso,
                                                               province_state: province_state,
                                                               admin2_county: admin2_county,
                                                               regions: regions,
                                                               sidebar_label: sidebar_label,
                                                               homepage_title: homepage_title)
      @central_areas[central_area.code] = central_area
      central_area.code
    end

    # @returns [Hash<String,CovidTracker::CentralAreaRegistration>] all registered central areas as code=area_registration
    def registry
      @central_areas
    end

    # empty the registry
    def clear_registry
      @central_areas = {}
    end
  end
end
