module XcodeResultBundleProcessor
  module TestSummaries
    class TestResult < KeywordStruct.new(:identifier, :passed?, :failure_summaries, :activities)
      def self.parse(test_result)
        TestResult.new(
            identifier:        test_result['TestIdentifier'],
            passed?:           test_result['TestStatus'] == 'Success',
            failure_summaries: Array(test_result['FailureSummaries']).map { |failure_summary| FailureSummary.parse(failure_summary) },
            activities:        Array(test_result['ActivitySummaries']).map { |activity_summary| Activity.parse(activity_summary) }
        )
      end

      def summary
        identifier + ' ' + if passed?
                             'Passed'
                           else
                             'Failed'
                           end
      end
    end

    class FailureSummary < KeywordStruct.new(:file_name, :line_number, :message)
      def self.parse(failure_summary)
        FailureSummary.new(
            file_name:   failure_summary['FileName'],
            line_number: failure_summary['LineNumber'],
            message:     failure_summary['Message']
        )
      end

      def location
        "#{file_name}:#{line_number}"
      end
    end

    class Activity < KeywordStruct.new(:title, :screenshot_path, :subactivities)
      def self.parse(activity_summary)
        screenshot      = Array(activity_summary['Attachments']).find { |attachment| attachment['Name'] == 'Screenshot' }
        screenshot_path = nil
        unless screenshot.nil?
          screenshot_path = screenshot['FileName']
        end

        Activity.new(
            title:           activity_summary['Title'],
            screenshot_path: screenshot_path,
            subactivities:   Array(activity_summary['SubActivities']).map { |subactivity| Activity.parse(subactivity) }
        )
      end
    end

    class TestSummaries
      attr_reader :tests

      def initialize(test_summaries)
        raise "FormatVersion is unsupported: <#{test_summaries['FormatVersion']}>" unless test_summaries['FormatVersion'] == '1.1'

        @tests = Array(test_summaries['TestableSummaries']).map do |testable_summary|
          Array(testable_summary['Tests']).map { |test| self._parse_test(test) }
        end.flatten.compact
      end

      def failed_tests
        tests.find_all { |test| !test.passed? }
      end

      def _parse_test(test)
        subtests = Array(test['Subtests'])
        if subtests.empty?
          TestResult.parse(test)
        else
          subtests.map { |subtest| self._parse_test(subtest) }
        end
      end
    end
  end
end