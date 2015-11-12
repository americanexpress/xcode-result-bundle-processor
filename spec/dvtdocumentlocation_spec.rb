require 'xcoderesultbundleprocessor/dvtdocumentlocation'

describe XcodeResultBundleProcessor::DVTDocumentLocation do

  describe '#deserialize' do
    it 'deserializes stream' do
      tokens = [
          'document URL',
          1234
      ]

      actual = XcodeResultBundleProcessor::DVTDocumentLocation.deserialize(tokens)

      expected = XcodeResultBundleProcessor::DVTDocumentLocation.new(
          document_url_string: 'document URL',
          timestamp:           1234
      )
      expect(actual).to eq(expected)
    end

  end

end