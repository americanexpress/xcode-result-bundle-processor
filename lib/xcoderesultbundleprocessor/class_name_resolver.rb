module XcodeResultBundleProcessor
  module ClassNameResolver

    ResolvedClassName = Struct.new(:class_name)

    def self.resolve_class_names(tokens)
      class_names = []

      Enumerator.new do |enumerator|
        tokens.each do |token|
          if token.is_a?(SLF0Tokenizer::ClassName)
            class_names << token.class_name
          elsif token.is_a?(SLF0Tokenizer::ClassNameRef)
            raise "Invalid ClassNameRef to class index #{token.class_name_id}" if token.class_name_id > class_names.length
            class_name = class_names[token.class_name_id - 1]
            enumerator.yield(ResolvedClassName.new(class_name))
          else
            enumerator.yield(token)
          end
        end
      end
    end

    def initialize(tokens)
      @class_names = []

      tokens = tokens.dup

      until tokens.empty?
        token = tokens.shift
        if token.is_a?(XcodeResultBundleProcessor::SLF0Tokenizer::ClassName)
          @class_names.push(token.class_name)
        end
      end
    end

    def resolve_class_name_reference(class_name_index)
      raise 'Invalid ClassNameRefs are 1-indexed' if class_name_index == 0
      raise "Invalid ClassNameRef to class index #{class_name_index}" if class_name_index > @class_names.length

      @class_names[class_name_index - 1]
    end
  end
end