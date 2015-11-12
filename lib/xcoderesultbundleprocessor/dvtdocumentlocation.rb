require_relative 'keyword_struct'

module XcodeResultBundleProcessor
  class DVTDocumentLocation < KeywordStruct.new(:document_url_string,
    :timestamp)

    def self.deserialize(tokens)
      self.new(
          document_url_string: tokens.shift,
          timestamp:           tokens.shift,
      )
    end
  end
end
