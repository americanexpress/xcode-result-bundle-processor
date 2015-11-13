require 'xcoderesultbundleprocessor/keyword_struct'

module XcodeResultBundleProcessor
  module SLF0
    module Model
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
  end
end
