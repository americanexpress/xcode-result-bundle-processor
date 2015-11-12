require_relative 'keyword_struct'

module XcodeResultBundleProcessor
  class IDEActivityLogUnitTestSection < KeywordStruct.new(*(IDEActivityLogSection.members + [:tests_passed_string, :duration_string, :summary_string,
                                                                                             :suite_name, :test_name, :performance_test_output_string]))

    def self.deserialize(tokens)
      parent        = IDEActivityLogSection.deserialize(tokens)
      parent_values = IDEActivityLogSection.members.map { |member| parent[member] }

      self.new(
          *(parent_values +
              [tokens.shift,
               tokens.shift,
               tokens.shift,
               tokens.shift,
               tokens.shift,
               tokens.shift])
      )
    end
  end
end
