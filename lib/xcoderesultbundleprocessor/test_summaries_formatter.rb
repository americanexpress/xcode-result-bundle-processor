module XcodeResultBundleProcessor
  module TestSummariesFormatter
    include Methadone::CLILogging

    def self.format(test_summaries)
      debug "Formatting test summaries <#{test_summaries.ai}"

      raise "FormatVersion is unsupported: <#{test_summaries['FormatVersion']}>" unless test_summaries['FormatVersion'] == '1.1'

      buffer = IndentedStringBuffer.new

      (test_summaries['TestableSummaries'] || []).each { |testable_summary| self._format_testable_summary(testable_summary, buffer) }

      buffer.to_s
    end

    private

    def self._format_testable_summary(testable_summary, buffer)
      buffer.add_line("#{testable_summary['TestName']} in #{testable_summary['ProjectPath']}\n", 0)
      (testable_summary['Tests'] || []).each { |test| self._format_test(test, 1, buffer) }.join("\n")
    end

    def self._format_test(test, indent, buffer)
      summary = test['TestIdentifier']
      summary << ' ' << test['TestStatus'] unless test['TestStatus'].nil?
      buffer.add_line(summary, indent)
      (test['FailureSummaries'] || []).each { |failure_summary| self._format_failure_summary(failure_summary, indent + 1, buffer) }

      unless test['ActivitySummaries'].nil?
        buffer.add_line('Timeline:', indent + 1)

        test['ActivitySummaries'].each { |activity_summary| self._format_activity_summary(activity_summary, indent + 2, buffer) }

      end

      (test['Subtests'] || []).each { |subtest| self._format_test(subtest, indent + 1, buffer) }
      buffer
    end

    def self._format_failure_summary(failure_summary, indent, buffer)
      buffer.add_line("Failure at #{failure_summary['FileName']}:#{failure_summary['LineNumber']}\n", indent)
      buffer.add_lines(failure_summary['Message'].each_line, indent + 1)
    end

    def self._format_activity_summary(activity_summary, indent, buffer)
      buffer.add_line(activity_summary['Title'], indent)
    end
  end
end