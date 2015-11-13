require 'xcoderesultbundleprocessor/slf0/model/dvtdocumentlocation'

module XcodeResultBundleProcessor
  module SLF0
    module Model
      describe DVTDocumentLocation do

        describe '#deserialize' do
          it 'deserializes stream' do
            tokens = [
                'document URL',
                1234
            ]

            actual = DVTDocumentLocation.deserialize(tokens)

            expected = DVTDocumentLocation.new(
                document_url_string: 'document URL',
                timestamp:           1234
            )
            expect(actual).to eq(expected)
          end

        end

      end
    end

  end

end
