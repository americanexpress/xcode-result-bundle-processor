require_relative 'keyword_struct'

module XcodeResultBundleProcessor
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
