module XcodeResultBundleProcessor
  module TestSummariesFormatter
    include Methadone::CLILogging

    def self.format(results_bundle)
      test_summaries = TestSummaries.new(results_bundle.read_plist('TestSummaries.plist'))

      buffer = IndentedStringBuffer.new

      test_summaries.tests.each { |test| self._format_test(test, buffer) }

      buffer.to_s
    end

    private

    def self._format_test(test, buffer)
      buffer << test.summary

      test.failure_summaries.each { |failure_summary| self._format_failure_summary(failure_summary, buffer.indent) }

      unless test.activities.empty?
        buffer.indent << 'Timeline:'

        buffer.indent.indent << test.activities.map(&:title)
      end
    end

    def self._format_failure_summary(failure_summary, buffer)
      buffer << "Failure at #{failure_summary.location}"
      buffer.indent << failure_summary.message.each_line
    end
  end
end