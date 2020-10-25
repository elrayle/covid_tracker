# frozen_string_literal: true

module CovidTracker
  class FileService
    # base directory contants
    GENERATOR_BASE_DIR = "docs"
    SITE_HOMEPAGE_BASE_DIRECTORY = GENERATOR_BASE_DIR
    AREA_HOMEPAGE_BASE_DIRECTORY = GENERATOR_BASE_DIR
    PAGE_BASE_DIRECTORY = File.join(GENERATOR_BASE_DIR, "pages", "covid_tracker")
    GRAPH_BASE_DIRECTORY = File.join("images", "covid_tracker")
    SIDEBAR_BASE_DIRECTORY = File.join(GENERATOR_BASE_DIR, "_data", "sidebars")
    SIDEBARCONFIGS_BASE_DIRECTORY = File.join(GENERATOR_BASE_DIR, "_includes", "custom")

    # file_type constants
    SITE_HOMEPAGE_FILE_TYPE = :site_homepage
    AREA_HOMEPAGE_FILE_TYPE = :area_homepage
    PAGE_SOURCE_FILE_TYPE = :page_source
    PAGE_TARGET_FILE_TYPE = :page_target
    GRAPH_FILE_TYPE = :graph
    SIDEBAR_FILE_TYPE = :sidebar
    SIDEBARCONFIGS_FILE_TYPE = :sidebarconfigs

    class << self
      # @param parts [Hash] parts used to construct the path and filename
      # @option file_type [Symbol] type of file being generated (e.g. :page, :graph, :sidebar)
      # @option central_area_code [String] code for the central area (e.g. 'usa-georgia-richmond')
      # @option region_code [String] code for a region near the central area (e.g. 'usa-georgia-columbia')
      # @option stat [String] name of stat being graphed  (e.g. 'delta_confirmed') NOTE: used for graph files only
      # @option tail_directory [String] directory within region to hold the pages (e.g. 'by_region', 'weekly_totals, 'this_week)
      # @option file_postfix [String] last part of the filename (e.g. '-by_region', '-weekly_totals', '-7_days', '_sidebar', '-30_days_graph')
      # @option local_testing [Boolean] false when generating for github deploy; true for local testing
      # @returns [String] path from central area code through filename (e.g. 'usa-georgia-richmond/this_week/usa-georgia-columbia-7_days')
      def perma_link(parts)
        File.join(relpath_for(parts), filename_for(parts))
      end

      # @param parts [Hash] parts used to construct the path and filename
      # @option file_type [Symbol] type of file being generated (e.g. :page, :graph, :sidebar)
      # @option central_area_code [String] code for the central area (e.g. 'usa-georgia-richmond')
      # @option region_code [String] code for a region near the central area (e.g. 'all_regions', 'usa-georgia-columbia')
      # @option tail_directory [String] directory within region to hold the pages (e.g. 'by_region', 'weekly_totals, 'this_week)
      # @option file_postfix [String] last part of the filename (e.g. '-by_region', '-weekly_totals', '-7_days')
      # @param content [String] content to write to the file
      def write_to_file(parts, content)
        full_filename = File.join(directory_for(parts), filename_for(parts))
        puts "  --  Writing page to #{full_filename}" # rubocop:disable Rails/Output
        file = File.new(full_filename, 'w')
        file << content
        file.close
      end

    private

      def directory_for(parts)
        dir_path = rootpath_for(parts)
        FileUtils.mkdir_p(dir_path) unless File.exist? dir_path
        dir_path
      end

      # Used for writing out generated files
      def rootpath_for(parts)
        case parts[:file_type]
        when SITE_HOMEPAGE_FILE_TYPE, AREA_HOMEPAGE_FILE_TYPE, SIDEBARCONFIGS_FILE_TYPE
          Rails.root.join(base_directory_for(parts))
        when PAGE_SOURCE_FILE_TYPE
          # e.g. '/User/MyUser/.../RAILS_ROOT/docs/pages/covid_tracker/usa-georgia-richmond/this_week'
          Rails.root.join(base_directory_for(parts), relpath_for(parts))
        when PAGE_TARGET_FILE_TYPE
          ""
        when GRAPH_FILE_TYPE, SIDEBAR_FILE_TYPE
          Rails.root.join(relpath_for(parts))
        end
      end

      def base_directory_for(parts)
        case parts[:file_type]
        when SITE_HOMEPAGE_FILE_TYPE
          SITE_HOMEPAGE_BASE_DIRECTORY
        when AREA_HOMEPAGE_FILE_TYPE
          AREA_HOMEPAGE_BASE_DIRECTORY
        when PAGE_SOURCE_FILE_TYPE, PAGE_TARGET_FILE_TYPE
          PAGE_BASE_DIRECTORY
        when GRAPH_FILE_TYPE
          GRAPH_BASE_DIRECTORY
        when SIDEBAR_FILE_TYPE
          SIDEBAR_BASE_DIRECTORY
        when SIDEBARCONFIGS_FILE_TYPE
          SIDEBARCONFIGS_BASE_DIRECTORY
        end
      end

      # Used to reference files from within _site
      def relpath_for(parts)
        case parts[:file_type]
        when PAGE_SOURCE_FILE_TYPE, PAGE_TARGET_FILE_TYPE
          # e.g. 'covid_tracker/usa-georgia-richmond/this_week'
          return File.join(app_dir, parts[:central_area_code], parts[:tail_directory]) if include_app_dir? parts
          # e.g. 'usa-georgia-richmond/this_week' if local_testing?
          File.join(parts[:central_area_code], parts[:tail_directory])
        when GRAPH_FILE_TYPE
          # i.e. 'docs/images/covid_tracker'
          base_directory_for(parts)
        when SIDEBAR_FILE_TYPE
          # i.e. 'docs/_data/sidebars'
          base_directory_for(parts)
        end
      end

      def filename_for(parts)
        case parts[:file_type]
        when SITE_HOMEPAGE_FILE_TYPE
          "index.md"
        when AREA_HOMEPAGE_FILE_TYPE
          # e.g. 'usa-georgia-richmond.md'
          "#{parts[:central_area_code]}.md"
        when PAGE_SOURCE_FILE_TYPE
          # e.g. 'usa-georgia-richmond/this_week/usa-georgia-columbia-7_days.md'   for page_source
          "#{parts[:region_code]}#{parts[:file_postfix]}.md"
        when PAGE_TARGET_FILE_TYPE
          # e.g. 'usa-georgia-richmond/this_week/usa-georgia-columbia-7_days.html' for page_target
          "#{parts[:region_code]}#{parts[:file_postfix]}.html"
        when GRAPH_FILE_TYPE
          # e.g. 'usa-georgia-richmond-delta_confirmed-7_days_graph.png'
          "#{parts[:region_code]}#{parts[:stat]}#{parts[:file_postfix]}.png"
        when SIDEBAR_FILE_TYPE
          # e.g. 'usa-georgia-richmond_sidebar.yml'
          "#{parts[:central_area_code]}#{parts[:file_postfix]}.yml"
        when SIDEBARCONFIGS_FILE_TYPE
          "sidebarconfigs.html"
        end
      end

      def include_app_dir?(parts)
        parts.fetch(:include_app_dir, false)
      end

      def app_dir
        CovidTracker::SiteGeneratorService.app_dir
      end
    end
  end
end
