# frozen_string_literal: true

module CovidTracker
  class FileService
    PAGE_BASE_DIRECTORY = File.join("docs", "pages", "covid_tracker")
    GRAPH_BASE_DIRECTORY = File.join("docs", "images", "covid_tracker", "graphs")
    SIDEBAR_BASE_DIRECTORY = File.join("docs", "_data", "covid_tracker", "sidebars")

    PAGE_SOURCE_FILE_TYPE = :page_source
    PAGE_TARGET_FILE_TYPE = :page_target
    GRAPH_FILE_TYPE = :graph
    SIDEBAR_FILE_TYPE = :sidebar_source

    class << self
      # @param parts [Hash] parts used to construct the path and filename
      # @option file_type [Symbol] type of file being generated (e.g. :page, :graph, :sidebar)
      # @option central_area_code [String] code for the central area (e.g. 'usa-georgia-richmond')
      # @option region_code [String] code for a region near the central area (e.g. 'all_regions', 'usa-georgia-columbia')
      # @option tail_directory [String] directory within region to hold the pages (e.g. 'by_region', 'weekly_totals, 'this_week)
      # @option file_postfix [String] last part of the filename (e.g. '-by_region', '-weekly_totals', '-7_days')
      # @returns [String] path from docs through filename (e.g. '/Users/myuser/RAILSAPP_PATH/docs/pages/covid_tracker/usa-georgia-richmond/this_week/usa-georgia-columbia-7_days')
      def rootpath_and_filename(parts)
        File.join(rootpath(parts), filename(parts))
      end

      # @param parts [Hash] parts used to construct the path and filename
      # @option file_type [Symbol] type of file being generated (e.g. :page, :graph, :sidebar)
      # @option central_area_code [String] code for the central area (e.g. 'usa-georgia-richmond')
      # @option region_code [String] code for a region near the central area (e.g. 'all_regions', 'usa-georgia-columbia')
      # @option tail_directory [String] directory within region to hold the pages (e.g. 'by_region', 'weekly_totals, 'this_week)
      # @returns [String] path from docs through filename (e.g. '/Users/myuser/RAILSAPP_PATH/docs/pages/covid_tracker/usa-georgia-richmond/this_week/usa-georgia-columbia-7_days')
      def rootpath(parts)
        Rails.root.join(full_relpath(parts))
      end

      # @param parts [Hash] parts used to construct the path and filename
      # @option file_type [Symbol] type of file being generated (e.g. :page, :graph, :sidebar)
      # @option central_area_code [String] code for the central area (e.g. 'usa-georgia-richmond')
      # @option region_code [String] code for a region near the central area (e.g. 'all_regions', 'usa-georgia-columbia')
      # @option tail_directory [String] directory within region to hold the pages (e.g. 'by_region', 'weekly_totals, 'this_week)
      # @option file_postfix [String] last part of the filename (e.g. '-by_region', '-weekly_totals', '-7_days')
      # @returns [String] path from docs through filename (e.g. 'docs/pages/covid_tracker/usa-georgia-richmond/this_week/usa-georgia-columbia-7_days')
      def full_relpath_and_filename(parts)
        File.join(full_relpath(parts), filename(parts))
      end

      # @param parts [Hash] parts used to construct the path and filename
      # @option file_type [Symbol] type of file being generated (e.g. :page, :graph, :sidebar)
      # @option central_area_code [String] code for the central area (e.g. 'usa-georgia-richmond')
      # @option region_code [String] code for a region near the central area (e.g. 'all_regions', 'usa-georgia-columbia')
      # @option tail_directory [String] directory within region to hold the pages (e.g. 'by_region', 'weekly_totals, 'this_week)
      # @returns [String] path from docs through filename (e.g. 'docs/pages/covid_tracker/usa-georgia-richmond/this_week/usa-georgia-columbia-7_days')
      def full_relpath(parts)
        File.join(directory_by(file_type: parts[:file_type]), area_relpath(parts))
      end

      # @param parts [Hash] parts used to construct the path and filename
      # @option file_type [Symbol] type of file being generated (e.g. :page, :graph, :sidebar)
      # @option central_area_code [String] code for the central area (e.g. 'usa-georgia-richmond')
      # @option region_code [String] code for a region near the central area (e.g. 'usa-georgia-columbia')
      # @option tail_directory [String] directory within region to hold the pages (e.g. 'by_region', 'weekly_totals, 'this_week)
      # @option file_postfix [String] last part of the filename (e.g. '-by_region', '-weekly_totals', '-7_days')
      # @returns [String] path from central area code through filename (e.g. 'usa-georgia-richmond/this_week/usa-georgia-columbia-7_days')
      def area_relpath_and_filename(parts)
        File.join(area_relpath(parts), filename(parts))
      end
      alias perma_link area_relpath_and_filename

      # @param parts [Hash] parts used to construct the path and filename
      # @option central_area_code [String] code for the central area (e.g. 'usa-georgia-richmond')
      # @option tail_directory [String] directory within region to hold the pages (e.g. 'by_region', 'weekly_totals, 'this_week)
      # @returns [String] area directory (e.g. 'usa-georgia-richmond/this_week')
      def area_relpath(parts)
        File.join(parts[:central_area_code], parts[:tail_directory])
      end

      # @param parts [Hash] parts used to construct the path and filename
      # @option file_type [Symbol] type of file being generated (e.g. :page, :graph, :sidebar)
      # @option region_code [String] code for a region near the central area (e.g. 'all_regions', 'usa-georgia-columbia')
      # @option file_postfix [String] last part of the filename (e.g. '-by_region', '-weekly_totals', '-7_days')
      # @returns [String] filename without extension (e.g. 'usa-georgia-richmond/this_week/usa-georgia-columbia-7_days')
      def filename(parts)
        "#{parts[:region_code]}#{parts[:file_postfix]}#{extension_by(file_type: parts[:file_type])}"
      end

      # @param parts [Hash] parts used to construct the path and filename
      # @option file_type [Symbol] type of file being generated (e.g. :page, :graph, :sidebar)
      # @option central_area_code [String] code for the central area (e.g. 'usa-georgia-richmond')
      # @option region_code [String] code for a region near the central area (e.g. 'all_regions', 'usa-georgia-columbia')
      # @option tail_directory [String] directory within region to hold the pages (e.g. 'by_region', 'weekly_totals, 'this_week)
      # @option file_postfix [String] last part of the filename (e.g. '-by_region', '-weekly_totals', '-7_days')
      # @param content [String] content to write to the file
      def write_to_file(parts, content)
        create_rootpath_if_needed(parts)
        full_file_name = rootpath_and_filename(parts)
        puts "  --  Writing page to #{full_file_name}" # rubocop:disable Rails/Output
        file = File.new(full_file_name, 'w')
        file << content
        file.close
      end

    private

      def create_rootpath_if_needed(parts)
        dir_path = rootpath(parts)
        FileUtils.mkdir_p(dir_path) unless File.exist? dir_path
      end

      def directory_by(file_type:)
        case file_type
        when :page_source
          PAGE_BASE_DIRECTORY
        when :page_target
          ""
        when :graph
          GRAPH_BASE_DIRECTORY
        when :sidebar
          SIDEBAR_BASE_DIRECTORY
        end
      end

      def extension_by(file_type:)
        case file_type
        when :page_source
          ".md"
        when :page_target
          ".html"
        when :graph
          ".png"
        when :sidebar
          ".yml"
        end
      end
    end
  end
end
