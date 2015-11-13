require 'methadone'
require 'awesome_print'
require 'xcoderesultbundleprocessor/slf0/model/ideactivitylogsection'
require 'xcoderesultbundleprocessor/slf0/model/ideactivitylogunittestsection'
require 'xcoderesultbundleprocessor/slf0/model/ideactivitylogmessage'
require 'xcoderesultbundleprocessor/slf0/model/dvtdocumentlocation'
require 'xcoderesultbundleprocessor/slf0/model/dvttextdocumentlocation'

module XcodeResultBundleProcessor
  module SLF0
    module Deserializer
      include Methadone::CLILogging

      def self.deserialize(tokens)
        debug "Deserializing #{tokens.ai}"

        if tokens.first.nil?
          tokens.shift
          return nil
        end

        self._assert_first_token_type(ClassNameResolver::ResolvedClassName, tokens)

        resolved_class = tokens.shift
        return nil if resolved_class.nil?

        class_name = resolved_class.class_name
        raise "Unsupported class #{class_name}" unless Model.const_defined?(class_name)

        Model.const_get(class_name).deserialize(tokens)
      end

      def self.deserialize_list(tokens)
        if tokens.first.nil?
          tokens.shift
          return []
        end

        self._assert_first_token_type(Tokenizer::ObjectList, tokens)

        object_list_info = tokens.shift

        object_list_info.mystery_number.times.map { Deserializer.deserialize(tokens) }
      end

      private

      def self._assert_first_token_type(expected_type, tokens)
        raise "First token should be #{expected_type} but was a <#{tokens.first}>" unless tokens.first.is_a?(expected_type)
      end
    end
  end
end