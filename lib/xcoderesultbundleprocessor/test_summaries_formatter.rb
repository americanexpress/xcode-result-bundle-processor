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
      buffer << "#{testable_summary['TestName']} in #{testable_summary['ProjectPath']}"
      (testable_summary['Tests'] || []).each { |test| self._format_test(test, buffer.indent) }
    end

    def self._format_test(test, buffer)
      summary = test['TestIdentifier']
      summary << ' ' << test['TestStatus'] unless test['TestStatus'].nil?
      buffer << summary
      (test['FailureSummaries'] || []).each { |failure_summary| self._format_failure_summary(failure_summary, buffer.indent) }

      unless test['ActivitySummaries'].nil?
        buffer.indent << 'Timeline:'

        test['ActivitySummaries'].each { |activity_summary| self._format_activity_summary(activity_summary, buffer.indent.indent) }
      end

      (test['Subtests'] || []).each { |subtest| self._format_test(subtest, buffer.indent) }
      buffer
    end

    def self._format_failure_summary(failure_summary, buffer)
      buffer << "Failure at #{failure_summary['FileName']}:#{failure_summary['LineNumber']}\n"
      buffer.indent << failure_summary['Message'].each_line
    end

    def self._format_activity_summary(activity_summary, buffer)
      buffer << activity_summary['Title']
    end
  end
end