module XcodeResultBundleProcessor
  module TestSummariesFormatter
    include Methadone::CLILogging

    def self.format(test_summaries)
      debug "Formatting test summaries <#{test_summaries.ai}"

      raise "FormatVersion is unsupported: <#{test_summaries['FormatVersion']}>" unless test_summaries['FormatVersion'] == '1.1'

      (test_summaries['TestableSummaries'] || []).map { |testable_summary| self._format_testable_summary(testable_summary) }.join("\n") + "\n"
    end

    private

    def self._format_testable_summary(testable_summary)
      "#{testable_summary['TestName']} in #{testable_summary['ProjectPath']}\n" << (testable_summary['Tests'] || []).map { |test| self._format_test(test, 2) }.join("\n")
    end

    def self._format_test(test, indent)
      summary = ' '*indent << test['TestIdentifier']
      summary << ' ' << test['TestStatus'] unless test['TestStatus'].nil?
      lines = [summary]
      lines += (test['FailureSummaries'] || []).map { |failure_summary| self._format_failure_summary(failure_summary, indent + 2) }

      unless test['ActivitySummaries'].nil?
        lines << (' '*(indent + 2) << 'Timeline:')
        lines += test['ActivitySummaries'].map { |activity_summary| self._format_activity_summary(activity_summary, indent + 4) }

      end

      lines += (test['Subtests'] || []).map { |subtest| self._format_test(subtest, indent + 2) }
      lines.join("\n")
    end

    def self._format_failure_summary(failure_summary, indent)
      lines = [' ' * indent << "Failure at #{failure_summary['FileName']}:#{failure_summary['LineNumber']}\n"]

      lines += failure_summary['Message'].each_line.map { |line| ' ' * (indent + 2) << line }

      lines.join
    end

    def self._format_activity_summary(activity_summary, indent)
      ' ' * indent << activity_summary['Title']
    end
  end
end