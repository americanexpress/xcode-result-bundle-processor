module XcodeResultBundleProcessor
  module SLF0
    module Model

      describe IDEConsoleItem do

        describe '#deserialize' do
          it 'deserializes stream' do
            tokens = [
                'adaptor type',
                'content',
                1234,
                0
            ]

            actual = IDEConsoleItem.deserialize(tokens)

            expected = IDEConsoleItem.new(
                adaptor_type: 'adaptor type',
                content:      'content',
                kind:         1234,
                timestamp:    0
            )
            expect(actual).to eq(expected)
          end

        end

      end
    end

  end

end