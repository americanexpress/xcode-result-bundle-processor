require 'xcoderesultbundleprocessor/dvttextdocumentlocation'

describe XcodeResultBundleProcessor::DVTTextDocumentLocation do

  describe '#deserialize' do
    it 'deserializes stream' do
      tokens = [
          'document URL',
          1234,
          1,
          2,
          3,
          4,
          5,
          6,
          7
      ]

      actual = XcodeResultBundleProcessor::DVTTextDocumentLocation.deserialize(tokens)

      expected = XcodeResultBundleProcessor::DVTTextDocumentLocation.new(
          document_url_string:    'document URL',
          timestamp:              1234,
          starting_line_number:   1,
          starting_column_number: 2,
          ending_line_number:     3,
          ending_column_number:   4,
          character_range_1:      5,
          character_range_2:      6,
          location_encoding:      7

      )
      expect(actual).to eq(expected)
    end

  end

end