# frozen_string_literal: true

module CovidTracker
  class RegionRegistration
    attr_accessor :country_iso, :province_state, :admin2_county

    def initialize(country_iso: nil, province_state: nil, admin2_county: nil)
      validate(country_iso, province_state, admin2_county)
      @country_iso = country_iso
      @province_state = province_state
      @admin2_county = admin2_county
    end

    def code
      code = ""
      code += country_iso.to_s if country_iso
      code += "-#{province_state}" if province_state
      code += "-#{admin2_county}" if admin2_county
      code.tr(' ', '_').downcase
    end

    def label
      label = ""
      label += "#{admin2_county}, " if admin2_county
      label += "#{province_state}, " if province_state
      label += country_iso.to_s if country_iso
      label
    end

  private

    def validate(country_iso, province_state, admin2_county)
      raise ArgumentError, "province_state must be defined to include admin2_county" if admin2_county && !province_state
      # raise ArgumentError, "country_iso must be defined to include province_state" if province_state && !country_iso
      raise ArgumentError, "country_iso is required" unless country_iso
    end
  end
end
