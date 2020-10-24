# frozen_string_literal: true

module CovidTracker
  class CentralAreaRegistration
    attr_accessor :country_iso, :province_state, :admin2_county, :regions, :sidebar_label, :homepage_title

    # @param country_iso [String] country iso for the region at the center of this group of regions
    # @param province_state [String] province or US state for the region at the center of this group of regions
    # @param admin2_county [String] admin2 level or US county for the region at the center of this group of regions
    # @param regions [Array<CovidTracker::Region>] the central area region and regions surrounding the central area
    # @param sidebar_label [String] shorter label to display in above sidebar menu (defaults to central area's region label)
    # @param homepage_title [String] title to display on the homepage for this central area (defaults to central area's region label)
    # @returns [CovidTracker::CentralAreaRegistration] new instance of this class
    def initialize(country_iso: nil, province_state: nil, admin2_county: nil, # rubocop:disable Metrics/ParameterLists
                   regions: nil, sidebar_label: nil, homepage_title: nil)
      validate(regions, country_iso, province_state, admin2_county)
      @country_iso = country_iso
      @province_state = province_state
      @admin2_county = admin2_county
      @regions = regions
      @sidebar_label = sidebar_label || label
      @homepage_title = homepage_title || label
    end

    # @returns [String] the code for the central area's region (e.g. 'usa-alabama-wilcox')
    def code
      code = ""
      code += country_iso.to_s if country_iso.present?
      code += "-#{province_state}" if province_state.present?
      code += "-#{admin2_county}" if admin2_county.present?
      code.tr(' ', '_').downcase
    end

    # @returns [String] the label for the central area's region (e.g. 'Wilcox, Alabama, USA')
    def label
      label = ""
      label += "#{admin2_county}, " if admin2_county.present?
      label += "#{province_state}, " if province_state.present?
      label += country_iso.to_s if country_iso.present?
      label
    end

  private

    def validate(regions, country_iso, province_state, admin2_county)
      raise ArgumentError, "regions is required" if regions.blank?
      raise ArgumentError, "country_iso is required" if country_iso.blank?
      raise ArgumentError, "province_state must be defined to include admin2_county" if admin2_county.present? && province_state.blank?
    end
  end
end
