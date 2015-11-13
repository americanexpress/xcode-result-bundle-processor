require 'awesome_print'
require 'methadone'

module XcodeResultBundleProcessor
  module ActivityLogFormatter
    include Methadone::CLILogging

    def self.format(section)
      debug "Formatting activity log section #{section.ai}"

      return "\n" if section.nil?

      # The top-level section contains the complete log for all test runs, so grabbing that text is enough to
      # get the full log
      section = section.subsections.first

      ret = section.title << "\n"

      section.text.each_line do |line|
        ret << line
      end

      ret << "\n"
    end
  end
end