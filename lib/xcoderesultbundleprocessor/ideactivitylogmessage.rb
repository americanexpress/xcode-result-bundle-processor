require_relative 'keyword_struct'

module XcodeResultBundleProcessor
  class IDEActivityLogMessage < KeywordStruct.new(
      :title, :short_title, :time_emitted, :range_in_section_text_1, :range_in_section_text_2, :submessages, :severity, :type, :location, :category_ident, :secondary_locations, :additional_description)

    def self.deserialize(tokens)
      self.new(
          title:                   tokens.shift,
          short_title:             tokens.shift,
          time_emitted:            tokens.shift,
          range_in_section_text_1: tokens.shift,
          range_in_section_text_2: tokens.shift,
          submessages:             SLF0Deserializer.deserialize_list(tokens),
          severity:                tokens.shift,
          type:                    tokens.shift,
          location:                SLF0Deserializer.deserialize(tokens),
          category_ident:          tokens.shift,
          secondary_locations:     SLF0Deserializer.deserialize_list(tokens),
          additional_description:  tokens.shift
      )
    end
  end
end