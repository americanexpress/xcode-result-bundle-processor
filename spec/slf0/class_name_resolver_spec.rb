module XcodeResultBundleProcessor
  module SLF0
    RSpec.describe ClassNameResolver do
      describe '#resolve_class_names' do
        it 'resolves multiple class name references' do
          tokens          = [
              Tokenizer::ClassName.new('ThisIsAClass'),
              Tokenizer::ClassNameRef.new(1),
              Tokenizer::ClassName.new('AnotherClass'),
              Tokenizer::ClassName.new('ThirdClass'),
              Tokenizer::ClassNameRef.new(2),
              Tokenizer::ClassNameRef.new(3),
              Tokenizer::ClassNameRef.new(2),
          ]
          resolved_tokens = ClassNameResolver.resolve_class_names(tokens).to_a

          expected_tokens = [
              ClassNameResolver::ResolvedClassName.new('ThisIsAClass'),
              ClassNameResolver::ResolvedClassName.new('AnotherClass'),
              ClassNameResolver::ResolvedClassName.new('ThirdClass'),
              ClassNameResolver::ResolvedClassName.new('AnotherClass'),
          ]
          expect(resolved_tokens).to eq(expected_tokens)
        end

        it 'errors for invalid class name reference' do
          expect { ClassNameResolver.resolve_class_names([Tokenizer::ClassNameRef.new(3)]).to_a }.to raise_error('Invalid ClassNameRef to class index 3')
        end
      end
    end
  end
end
