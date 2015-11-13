require 'xcoderesultbundleprocessor/keyword_struct'

module XcodeResultBundleProcessor
  module SLF0
    module Model
      class IDEActivityLogMessage < KeywordStruct.new(
          :title, :short_title, :time_emitted, :range_in_section_text_1, :range_in_section_text_2, :submessages, :severity, :type, :location, :category_ident, :secondary_locations, :additional_description)

        def self.deserialize(tokens)
          self.new(
              title:                   tokens.shift,
              short_title:             tokens.shift,
              time_emitted:            tokens.shift,
              range_in_section_text_1: tokens.shift,
              range_in_section_text_2: tokens.shift,
              submessages:             Deserializer.deserialize_list(tokens),
              severity:                tokens.shift,
              type:                    tokens.shift,
              location:                Deserializer.deserialize(tokens),
              category_ident:          tokens.shift,
              secondary_locations:     Deserializer.deserialize_list(tokens),
              additional_description:  tokens.shift
          )
        end
      end
    end
  end
end