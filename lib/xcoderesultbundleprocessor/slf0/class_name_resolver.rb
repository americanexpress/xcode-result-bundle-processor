module XcodeResultBundleProcessor
  module SLF0
    module ClassNameResolver

      ResolvedClassName = Struct.new(:class_name)

      def self.resolve_class_names(tokens)
        class_names = []

        Enumerator.new do |enumerator|
          tokens.each do |token|
            if token.is_a?(Tokenizer::ClassName)
              class_names << token.class_name
            elsif token.is_a?(Tokenizer::ClassNameRef)
              raise "Invalid ClassNameRef to class index #{token.class_name_id}" if token.class_name_id > class_names.length
              class_name = class_names[token.class_name_id - 1]
              enumerator.yield(ResolvedClassName.new(class_name))
            else
              enumerator.yield(token)
            end
          end
        end
      end
    end
  end
end