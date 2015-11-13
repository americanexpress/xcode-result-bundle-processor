module XcodeResultBundleProcessor
  module SLF0
    module Model
      describe IDEActivityLogMessage do

        describe '#deserialize' do
          it 'deserializes stream with no submessages or sublocations' do
            tokens = [
                'title',
                'short title',
                123,
                456,
                789,
                nil,
                4,
                'type',
                nil,
                'category ident',
                nil,
                'additional desc'
            ]

            actual = IDEActivityLogMessage.deserialize(tokens)

            expected = IDEActivityLogMessage.new(
                title:                   'title',
                short_title:             'short title',
                time_emitted:            123,
                range_in_section_text_1: 456,
                range_in_section_text_2: 789,
                submessages:             [],
                severity:                4,
                type:                    'type',
                location:                nil,
                category_ident:          'category ident',
                secondary_locations:     [],
                additional_description:  'additional desc')
            expect(actual).to eq(expected)
          end

        end

      end
    end

  end

end