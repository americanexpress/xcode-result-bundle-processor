module XcodeResultBundleProcessor
  describe TestSummariesFormatter do
    describe '#format' do
      it 'raises for unsupported version' do
        expect { TestSummariesFormatter.format({'FormatVersion' => 'foo'}) }.to raise_error('FormatVersion is unsupported: <foo>')
      end

      it 'displays test names hierarchically' do
        expected = [
            'TheTestName in TheProjectPath',
            '  Test 1',
            '    Test 1.1',
            '      Test 1.1.1',
            '    Test 1.2'
        ].join("\n") + "\n"

        actual = TestSummariesFormatter.format({'FormatVersion' => '1.1', 'TestableSummaries' => [
            {
                'ProjectPath' => 'TheProjectPath',
                'TestName'    => 'TheTestName',
                'Tests'       => [
                    {
                        'TestIdentifier' => 'Test 1',
                        'Subtests'       => [
                            {
                                'TestIdentifier' => 'Test 1.1',
                                'Subtests'       => [
                                    {
                                        'TestIdentifier' => 'Test 1.1.1'
                                    }
                                ]
                            },
                            {
                                'TestIdentifier' => 'Test 1.2'
                            }
                        ]
                    }
                ]
            }
        ]}, )

        expect(actual).to eq(expected)
      end

      it 'displays test status' do
        actual = TestSummariesFormatter.format({'FormatVersion' => '1.1', 'TestableSummaries' => [
            {
                'ProjectPath' => 'TheProjectPath',
                'TestName'    => 'TheTestName',
                'Tests'       => [
                    {
                        'TestIdentifier' => 'TheTestIdentifier',
                        'TestStatus'     => 'TheTestStatus'
                    }
                ]
            }
        ]})

        expected = [
            'TheTestName in TheProjectPath',
            '  TheTestIdentifier TheTestStatus'
        ].join("\n") + "\n"

        expect(actual).to eq(expected)
      end


      it 'displays empty summaries as empty string' do
        expect(TestSummariesFormatter.format({'FormatVersion' => '1.1'})).to eq("\n")
      end
    end

    describe '#_format_failure_summary' do
      it 'displays test failure summaries with indented newlines' do
        expected = [
            '  Failure at somefile:1234',
            '    Line one of failure',
            '    Line two of failure'
        ].join("\n") + "\n"

        buffer = IndentedStringBuffer.new
        actual = TestSummariesFormatter._format_failure_summary({
                                                                    'FileName'   => 'somefile',
                                                                    'LineNumber' => 1234,
                                                                    'Message'    => "Line one of failure\nLine two of failure"
                                                                }, 1, buffer)

        expect(actual).to eq(expected)
      end
    end

    describe '#_format_activity_summary' do
      it 'displays summary' do
        buffer = IndentedStringBuffer.new
        actual                 = TestSummariesFormatter._format_activity_summary({
                                                                    'Title' => 'TheTitle'
                                                                }, 1, buffer)
        expect(actual).to eq("  TheTitle\n")
      end
    end
  end
end