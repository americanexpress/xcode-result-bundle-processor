module XcodeResultBundleProcessor
  module SLF0
    module Model
      class DVTTextDocumentLocation < KeywordStruct.new(*(DVTDocumentLocation.members + [:starting_line_number, :starting_column_number, :ending_line_number, :ending_column_number, :character_range_1, :character_range_2, :location_encoding]))

        def self.deserialize(tokens)
          parent        = DVTDocumentLocation.deserialize(tokens)
          parent_values = DVTDocumentLocation.members.map { |member| parent[member] }

          self.new(*(parent_values + [
              tokens.shift,
              tokens.shift,
              tokens.shift,
              tokens.shift,
              tokens.shift,
              tokens.shift,
              tokens.shift,
          ]))
        end
      end
    end
  end
end
