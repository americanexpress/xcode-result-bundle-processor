require 'xcoderesultbundleprocessor/ideactivitylogsection'

describe XcodeResultBundleProcessor::IDEActivityLogSection do

  describe '#deserialize' do
    it 'deserializes stream with no subsections' do
      tokens = [
          1,
          'foo.bar.baz',
          'title',
          'signature',
          1234,
          5678,
          nil,
          'the main text',
          nil,
          0,
          1,
          0,
          'subtitle',
          nil,
          'command detail',
          '1234-5678',
          'localized!'
      ]

      actual = XcodeResultBundleProcessor::IDEActivityLogSection.deserialize(tokens)

      expected = XcodeResultBundleProcessor::IDEActivityLogSection.new(
          section_type:            1,
          domain_type:             'foo.bar.baz',
          title:                   'title',
          signature:               'signature',
          time_started_recording:  1234,
          time_stopped_recording:  5678,
          subsections:             [],
          text:                    'the main text',
          messages:                [],
          cancelled?:              false,
          quiet?:                  true,
          fetched_from_cache?:     false,
          subtitle:                'subtitle',
          location:                nil,
          command_detail_desc:     'command detail',
          uuid:                    '1234-5678',
          localized_result_string: 'localized!')
      expect(actual).to eq(expected)
    end

    it 'deserializes stream with subsections' do
      tokens = [
          1,
          'foo.bar.baz',
          'title',
          'signature',
          1234,
          5678,
          # Subsections
          XcodeResultBundleProcessor::SLF0Tokenizer::ObjectList.new(3),
          XcodeResultBundleProcessor::ClassNameResolver::ResolvedClassName.new('IDEActivityLogSection'),
          1,
          'foo.bar.baz',
          'title',
          'signature',
          1234,
          5678,
          nil,
          'the main text',
          nil,
          0,
          1,
          0,
          'subtitle',
          nil,
          'command detail',
          '1234-5678',
          'localized!',
          # End of subsection 1
          XcodeResultBundleProcessor::ClassNameResolver::ResolvedClassName.new('IDEActivityLogSection'),
          1,
          'foo.bar.baz',
          'title',
          'signature',
          1234,
          5678,
          nil,
          'the main text',
          nil,
          0,
          1,
          0,
          'subtitle',
          nil,
          'command detail',
          '1234-5678',
          'localized!',
          # End of subsection 2
          XcodeResultBundleProcessor::ClassNameResolver::ResolvedClassName.new('IDEActivityLogSection'),
          1,
          'foo.bar.baz',
          'title',
          'signature',
          1234,
          5678,
          nil,
          'the main text',
          nil,
          0,
          1,
          0,
          'subtitle',
          nil,
          'command detail',
          '1234-5678',
          'localized!',
          # End of subsection 3
          # End of subsections
          'the main text',
          nil,
          0,
          1,
          0,
          'subtitle',
          nil,
          'command detail',
          '1234-5678',
          'localized!'
      ]

      actual = XcodeResultBundleProcessor::IDEActivityLogSection.deserialize(tokens)

      expected_subsection = XcodeResultBundleProcessor::IDEActivityLogSection.new(
          section_type:            1,
          domain_type:             'foo.bar.baz',
          title:                   'title',
          signature:               'signature',
          time_started_recording:  1234,
          time_stopped_recording:  5678,
          subsections:             [],
          text:                    'the main text',
          messages:                [],
          cancelled?:              false,
          quiet?:                  true,
          fetched_from_cache?:     false,
          subtitle:                'subtitle',
          location:                nil,
          command_detail_desc:     'command detail',
          uuid:                    '1234-5678',
          localized_result_string: 'localized!')
      expected            = XcodeResultBundleProcessor::IDEActivityLogSection.new(
          section_type:            1,
          domain_type:             'foo.bar.baz',
          title:                   'title',
          signature:               'signature',
          time_started_recording:  1234,
          time_stopped_recording:  5678,
          subsections:             [expected_subsection, expected_subsection, expected_subsection],
          text:                    'the main text',
          messages:                [],
          cancelled?:              false,
          quiet?:                  true,
          fetched_from_cache?:     false,
          subtitle:                'subtitle',
          location:                nil,
          command_detail_desc:     'command detail',
          uuid:                    '1234-5678',
          localized_result_string: 'localized!')
      expect(actual).to eq(expected)
    end

    it 'deserializes stream with submessages' do
      tokens = [
          1,
          'foo.bar.baz',
          'title',
          'signature',
          1234,
          5678,
          nil,
          'the main text',
          # Start of submessages
          XcodeResultBundleProcessor::SLF0Tokenizer::ObjectList.new(1),
          XcodeResultBundleProcessor::ClassNameResolver::ResolvedClassName.new('IDEActivityLogMessage'),
          'title',
          'short title',
          123,
          456,
          789,
          nil,
          9,
          99,
          nil,
          'category ident',
          nil,
          'additional description',
          # End of submessages
          0,
          1,
          0,
          'subtitle',
          nil,
          'command detail',
          '1234-5678',
          'localized!'
      ]

      actual = XcodeResultBundleProcessor::IDEActivityLogSection.deserialize(tokens)

      expected = XcodeResultBundleProcessor::IDEActivityLogSection.new(
          section_type:            1,
          domain_type:             'foo.bar.baz',
          title:                   'title',
          signature:               'signature',
          time_started_recording:  1234,
          time_stopped_recording:  5678,
          subsections:             [],
          text:                    'the main text',
          messages:                [
                                       XcodeResultBundleProcessor::IDEActivityLogMessage.new(
                                           title:                   'title',
                                           short_title:             'short title',
                                           time_emitted:            123,
                                           range_in_section_text_1: 456,
                                           range_in_section_text_2: 789,
                                           submessages:             [],
                                           severity:                9,
                                           type:                    99,
                                           location:                nil,
                                           category_ident:          'category ident',
                                           secondary_locations:     [],
                                           additional_description:  'additional description'
                                       )
                                   ],
          cancelled?:              false,
          quiet?:                  true,
          fetched_from_cache?:     false,
          subtitle:                'subtitle',
          location:                nil,
          command_detail_desc:     'command detail',
          uuid:                    '1234-5678',
          localized_result_string: 'localized!')

      expect(actual).to eq(expected)
    end
  end

end