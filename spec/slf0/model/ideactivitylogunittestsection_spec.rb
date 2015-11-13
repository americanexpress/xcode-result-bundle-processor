module XcodeResultBundleProcessor
  module SLF0
    module Model

      describe IDEActivityLogUnitTestSection do

        describe '#deserialize' do
          it 'deserializes stream' do
            tokens = [
                'tests passed string',
                'duration string',
                'summary string',
                'suite name',
                'test name',
                'performance test output string',
            ]

            allow(IDEActivityLogSection).to receive(:deserialize).and_return(IDEActivityLogSection.new('i came from the mock'))

            actual = IDEActivityLogUnitTestSection.deserialize(tokens)

            expected = IDEActivityLogUnitTestSection.new(
                section_type:                   'i came from the mock',
                tests_passed_string:            'tests passed string',
                duration_string:                'duration string',
                summary_string:                 'summary string',
                suite_name:                     'suite name',
                test_name:                      'test name',
                performance_test_output_string: 'performance test output string')

            expect(actual).to eq(expected)
          end

        end

      end
    end

  end

end