require 'methadone'
require_relative 'ideactivitylogsection'
require_relative 'ideactivitylogunittestsection'
require_relative 'ideactivitylogmessage'
require_relative 'dvtdocumentlocation'
require_relative 'dvttextdocumentlocation'

module XcodeResultBundleProcessor
  module SLF0Deserializer
    include Methadone::CLILogging

    def self.deserialize(tokens)
      if tokens.first.nil?
        tokens.shift
        return nil
      end

      self._assert_first_token_type(ClassNameResolver::ResolvedClassName, tokens)

      resolved_class = tokens.shift
      return nil if resolved_class.nil?

      class_name = resolved_class.class_name
      raise "Unsupported class #{class_name}" unless XcodeResultBundleProcessor.const_defined?(class_name)

      XcodeResultBundleProcessor.const_get(class_name).deserialize(tokens)
    end

    def self.deserialize_list(tokens)
      if tokens.first.nil?
        tokens.shift
        return []
      end

      self._assert_first_token_type(SLF0Tokenizer::ObjectList, tokens)

      object_list_info = tokens.shift

      object_list_info.mystery_number.times.map { SLF0Deserializer.deserialize(tokens) }
    end

    private

    def self._assert_first_token_type(expected_type, tokens)
      raise "First token should be #{expected_type} but was a <#{tokens.first}>" unless tokens.first.is_a?(expected_type)
    end
  end
end