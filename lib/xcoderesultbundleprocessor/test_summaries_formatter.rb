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
      buffer.add_line("#{testable_summary['TestName']} in #{testable_summary['ProjectPath']}\n")
      (testable_summary['Tests'] || []).each { |test| self._format_test(test, buffer.indent) }.join("\n")
    end

    def self._format_test(test, buffer)
      summary = test['TestIdentifier']
      summary << ' ' << test['TestStatus'] unless test['TestStatus'].nil?
      buffer.add_line(summary)
      (test['FailureSummaries'] || []).each { |failure_summary| self._format_failure_summary(failure_summary, buffer.indent) }

      unless test['ActivitySummaries'].nil?
        buffer.indent.add_line('Timeline:')

        test['ActivitySummaries'].each { |activity_summary| self._format_activity_summary(activity_summary, buffer.indent.indent) }

      end

      (test['Subtests'] || []).each { |subtest| self._format_test(subtest, buffer.indent) }
      buffer
    end

    def self._format_failure_summary(failure_summary, buffer)
      buffer.add_line("Failure at #{failure_summary['FileName']}:#{failure_summary['LineNumber']}\n")
      buffer.indent.add_lines(failure_summary['Message'].each_line)
    end

    def self._format_activity_summary(activity_summary, buffer)
      buffer.add_line(activity_summary['Title'])
    end
  end
end