module XcodeResultBundleProcessor
  module TestSummaries
    describe TestSummaries do
      def make_test_summaries(testable_summaries=nil)
        {
            'FormatVersion'     => '1.1',
            'TestableSummaries' => testable_summaries
        }
      end

      describe '#initialize' do
        it 'raises for unsupported FormatVersion' do
          expect { TestSummaries.new({'FormatVersion' => '2.0'}) }.to raise_error 'FormatVersion is unsupported: <2.0>'
        end
      end

      describe '#tests' do
        it 'returns empty array for nil TestableSummaries' do
          expect(TestSummaries.new(make_test_summaries).tests).to eq([])
        end


        it 'collapses nested subtests' do
          test_summaries = make_test_summaries([
                                                   {
                                                       'Tests' => [
                                                           {'Subtests' => [
                                                               {'TestIdentifier' => 'Test 1'},
                                                               {'TestIdentifier' => 'Test 2'},
                                                           ]},
                                                           {'Subtests' => [
                                                               {'TestIdentifier' => 'Test 3'},
                                                               {'TestIdentifier' => 'Test 4'},
                                                           ]},
                                                       ]
                                                   },
                                                   {
                                                       'Tests' => [
                                                           {'Subtests' => [
                                                               {'TestIdentifier' => 'Test 5'},
                                                               {'TestIdentifier' => 'Test 6'},
                                                           ]},
                                                           {'Subtests' => [
                                                               {'TestIdentifier' => 'Test 7'},
                                                               {
                                                                   'Subtests' => [
                                                                       {'TestIdentifier' => 'Test 8'}
                                                                   ]},
                                                           ]},
                                                       ]
                                                   }
                                               ])


          expect(TestSummaries.new(test_summaries).tests.map(&:identifier)).to eq(['Test 1', 'Test 2', 'Test 3', 'Test 4', 'Test 5', 'Test 6', 'Test 7', 'Test 8'])
        end
      end

      describe '#failed_tests' do
        it 'returns empty if no failed tests' do
          test_summaries = make_test_summaries([
                                                   {'Tests' => [
                                                       {'TestIdentifier' => 'Passed', 'TestStatus' => 'Success'}
                                                   ]}
                                               ])

          expect(TestSummaries.new(test_summaries).failed_tests).to eq([])
        end

        it 'returns only failed tests' do
          test_summaries = make_test_summaries([
                                                   {'Tests' => [
                                                       {'TestIdentifier' => 'Fail1', 'TestStatus' => 'Failure'},
                                                       {'TestIdentifier' => 'Passed', 'TestStatus' => 'Success'},
                                                       {'TestIdentifier' => 'Fail2', 'TestStatus' => 'Failure'}
                                                   ]}
                                               ])
          expect(TestSummaries.new(test_summaries).failed_tests.map(&:identifier)).to eq(%w(Fail1 Fail2))
        end
      end

      describe 'individual test' do
        def make_test_summaries_for_test(test={})
          make_test_summaries([
                                  {
                                      'Tests' => [
                                          {
                                              'Subtests' => [
                                                  {'TestIdentifier' => 'Test 1'}.merge(test),
                                              ]
                                          }
                                      ]
                                  }
                              ])
        end

        it 'detects passed test' do
          test_summaries = make_test_summaries_for_test('TestStatus' => 'Success')

          expect(TestSummaries.new(test_summaries).tests.first.passed?).to be_truthy
        end

        it 'treats nil failure summaries as empty array' do
          expect(TestSummaries.new(make_test_summaries_for_test).tests.first.failure_summaries).to eq([])
        end

        it 'detects failed test' do
          test_summaries = make_test_summaries_for_test('TestStatus' => 'Failure')

          expect(TestSummaries.new(test_summaries).tests.first.passed?).to be_falsey
        end

        it 'includes failure summaries' do
          test_summaries = make_test_summaries_for_test('FailureSummaries' => [
              {'FileName' => 'file1', 'LineNumber' => 1234, 'Message' => 'Message1'},
              {'FileName' => 'file2', 'LineNumber' => 5678, 'Message' => 'Message2'},
          ])

          test = TestSummaries.new(test_summaries).tests.first
          expect(test.failure_summaries.length).to eq(2)
          expect(test.failure_summaries[0].file_name).to eq('file1')
          expect(test.failure_summaries[0].line_number).to eq(1234)
          expect(test.failure_summaries[0].message).to eq('Message1')

          expect(test.failure_summaries[1].file_name).to eq('file2')
          expect(test.failure_summaries[1].line_number).to eq(5678)
          expect(test.failure_summaries[1].message).to eq('Message2')
        end

        it 'treats nil activity summaries as empty array' do
          expect(TestSummaries.new(make_test_summaries_for_test).tests.first.activities).to eq([])
        end

        it 'includes activity summaries' do
          test_summaries = make_test_summaries_for_test('ActivitySummaries' => [
              {'Title' => 'Activity 1'},
              {'Title' => 'Activity 2'},
          ])

          test = TestSummaries.new(test_summaries).tests.first
          expect(test.activities.map(&:title)).to eq(['Activity 1', 'Activity 2'])
        end

        it 'returns empty array for nil subactivities' do
          test_summaries = make_test_summaries_for_test('ActivitySummaries' => [{}])

          test = TestSummaries.new(test_summaries).tests.first
          expect(test.activities.first.subactivities).to eq([])
        end

        it 'includes nested subactivities' do
          test_summaries = make_test_summaries_for_test('ActivitySummaries' => [
              {'SubActivities' => [
                  {'SubActivities' => [
                      {'Title' => 'Activity 1.1'},
                      {'Title' => 'Activity 1.2'},
                  ]},
                  {'SubActivities' => [
                      {'Title' => 'Activity 2.1'},
                      {'Title' => 'Activity 2.2'},
                  ]},
              ]},
          ])

          test = TestSummaries.new(test_summaries).tests.first
          expect(test.activities.length).to eq(1)
          activity = test.activities.first

          expect(activity.subactivities.length).to eq(2)
          expect(activity.subactivities[0].subactivities.map(&:title)).to eq(['Activity 1.1', 'Activity 1.2'])
          expect(activity.subactivities[1].subactivities.map(&:title)).to eq(['Activity 2.1', 'Activity 2.2'])
        end

        it 'includes subactivity screenshot if present' do
          test_summaries = make_test_summaries_for_test('ActivitySummaries' => [
              {'Attachments' => [
                  {'Name' => 'ElementsOfInterest', 'FileName' => 'elements'},
                  {'Name' => 'Screenshot', 'FileName' => 'screenie'},
              ]},
          ])

          activity = TestSummaries.new(test_summaries).tests.first.activities.first
          expect(activity.screenshot_path).to eq('screenie')
        end

        it 'has nil for screenshot if not present' do
          test_summaries = make_test_summaries_for_test('ActivitySummaries' => [
              {'Attachments' => [
                  {'Name' => 'ElementsOfInterest', 'FileName' => 'elements'},
              ]},
          ])

          activity = TestSummaries.new(test_summaries).tests.first.activities.first
          expect(activity.screenshot_path).to be_nil
        end
      end

      describe TestResult do
        describe '#summary' do
          it 'indicates success' do
            test_result = TestResult.new(identifier: 'TheID', passed?: true)

            expect(test_result.summary).to eq('TheID Passed')
          end

          it 'indicates failure' do
            test_result = TestResult.new(identifier: 'TheID', passed?: false)

            expect(test_result.summary).to eq('TheID Failed')
          end
        end
      end

      describe FailureSummary do
        describe '#location' do
          it 'combines file and line' do
            failure_summary = FailureSummary.new(file_name: 'somefile', line_number: 123)
            expect(failure_summary.location).to eq('somefile:123')
          end
        end
      end
    end
  end
end