require 'xcoderesultbundleprocessor/ideconsoleitem'

describe XcodeResultBundleProcessor::IDEConsoleItem do

  describe '#deserialize' do
    it 'deserializes stream' do
      tokens = [
          'adaptor type',
          'content',
          1234,
          0
      ]

      actual = XcodeResultBundleProcessor::IDEConsoleItem.deserialize(tokens)

      expected = XcodeResultBundleProcessor::IDEConsoleItem.new(
          adaptor_type: 'adaptor type',
          content:      'content',
          kind:         1234,
          timestamp:    0
      )
      expect(actual).to eq(expected)
    end

  end

end