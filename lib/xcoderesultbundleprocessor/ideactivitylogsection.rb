require_relative 'keyword_struct'

module XcodeResultBundleProcessor
  class IDEActivityLogSection < KeywordStruct.new(:section_type, :domain_type, :title, :signature, :time_started_recording, :time_stopped_recording, :subsections, :text, :messages, :cancelled?, :quiet?, :fetched_from_cache?, :subtitle, :location, :command_detail_desc, :uuid, :localized_result_string)
    def self.deserialize(tokens)
      self.new(
          section_type:            tokens.shift,
          domain_type:             tokens.shift,
          title:                   tokens.shift,
          signature:               tokens.shift,
          time_started_recording:  tokens.shift,
          time_stopped_recording:  tokens.shift,
          subsections:             SLF0Deserializer.deserialize_list(tokens),
          text:                    tokens.shift,
          messages:                SLF0Deserializer.deserialize_list(tokens),
          cancelled?:              tokens.shift == 1,
          quiet?:                  tokens.shift == 1,
          fetched_from_cache?:     tokens.shift == 1,
          subtitle:                tokens.shift,
          location:                tokens.shift,
          command_detail_desc:     tokens.shift,
          uuid:                    tokens.shift,
          localized_result_string: tokens.shift
      )
    end
  end
end