require 'xcoderesultbundleprocessor/class_name_resolver.rb'

RSpec.describe XcodeResultBundleProcessor::ClassNameResolver do
  describe '#resolve_class_names' do
    it 'resolves multiple class name references' do
      tokens          = [
          XcodeResultBundleProcessor::SLF0Tokenizer::ClassName.new('ThisIsAClass'),
          XcodeResultBundleProcessor::SLF0Tokenizer::ClassNameRef.new(1),
          XcodeResultBundleProcessor::SLF0Tokenizer::ClassName.new('AnotherClass'),
          XcodeResultBundleProcessor::SLF0Tokenizer::ClassName.new('ThirdClass'),
          XcodeResultBundleProcessor::SLF0Tokenizer::ClassNameRef.new(2),
          XcodeResultBundleProcessor::SLF0Tokenizer::ClassNameRef.new(3),
          XcodeResultBundleProcessor::SLF0Tokenizer::ClassNameRef.new(2),
      ]
      resolved_tokens = XcodeResultBundleProcessor::ClassNameResolver.resolve_class_names(tokens).to_a

      expected_tokens = [
          XcodeResultBundleProcessor::ClassNameResolver::ResolvedClassName.new('ThisIsAClass'),
          XcodeResultBundleProcessor::ClassNameResolver::ResolvedClassName.new('AnotherClass'),
          XcodeResultBundleProcessor::ClassNameResolver::ResolvedClassName.new('ThirdClass'),
          XcodeResultBundleProcessor::ClassNameResolver::ResolvedClassName.new('AnotherClass'),
      ]
      expect(resolved_tokens).to eq(expected_tokens)
    end

    it 'errors for invalid class name reference' do
      expect { XcodeResultBundleProcessor::ClassNameResolver.resolve_class_names([XcodeResultBundleProcessor::SLF0Tokenizer::ClassNameRef.new(3)]).to_a }.to raise_error('Invalid ClassNameRef to class index 3')
    end
  end
end
