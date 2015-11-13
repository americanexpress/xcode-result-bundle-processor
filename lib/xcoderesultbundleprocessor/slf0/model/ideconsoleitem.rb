require 'xcoderesultbundleprocessor/keyword_struct'

module XcodeResultBundleProcessor
  module SLF0
    module Model
      class IDEConsoleItem < KeywordStruct.new(:adaptor_type, :content, :kind, :timestamp)
        def self.deserialize(tokens)
          self.new(
              adaptor_type: tokens.shift,
              content:      tokens.shift,
              kind:         tokens.shift,
              timestamp:    tokens.shift,
          )
        end
      end
    end
  end
end
