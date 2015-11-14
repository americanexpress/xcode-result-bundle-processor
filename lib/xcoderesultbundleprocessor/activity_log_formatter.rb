require 'awesome_print'
require 'methadone'

module XcodeResultBundleProcessor
  module ActivityLogFormatter
    include Methadone::CLILogging

    def self.format(section)
      debug "Formatting activity log section #{section.ai}"

      return "\n" if section.nil?

      buffer = IndentedStringBuffer.new

      # The top-level section contains the complete log for all test runs, so grabbing that text is enough to
      # get the full log
      section = section.subsections.first

      buffer << section.title << section.text.each_line
      buffer.to_s
    end
  end
end