require 'xcoderesultbundleprocessor/slf0_deserializer'

describe XcodeResultBundleProcessor::SLF0Deserializer do
  describe '#deserialize' do
    it 'deserializes the given slf0 token stream' do
      class DummyClass
        def self.deserialize(tokens)
          'deserialized'
        end
      end

      actual = XcodeResultBundleProcessor::SLF0Deserializer.deserialize([XcodeResultBundleProcessor::ClassNameResolver::ResolvedClassName.new('DummyClass')])

      expect(actual).to eq('deserialized')
    end

    it 'returns nil for nil' do
      actual = XcodeResultBundleProcessor::SLF0Deserializer.deserialize([nil])

      expect(actual).to be_nil
    end

    it 'raises error when encountering unsupported class type' do
      expect { XcodeResultBundleProcessor::SLF0Deserializer.deserialize([XcodeResultBundleProcessor::ClassNameResolver::ResolvedClassName.new('InvalidClass')]) }.to raise_error('Unsupported class InvalidClass')
    end

    it 'raises error when first token is not resolved class' do
      expect { XcodeResultBundleProcessor::SLF0Deserializer.deserialize(['foo']) }.to raise_error('First token should be XcodeResultBundleProcessor::ClassNameResolver::ResolvedClassName but was a <foo>')
    end
  end

  describe '#deserialize_list' do
    it 'treats nil as empty array' do
      actual = XcodeResultBundleProcessor::SLF0Deserializer.deserialize_list([nil])
      expect(actual).to eq([])
    end

    it 'deserializes a list' do
      actual = XcodeResultBundleProcessor::SLF0Deserializer.deserialize_list([
                                                                                 XcodeResultBundleProcessor::SLF0Tokenizer::ObjectList.new(2),
                                                                                 XcodeResultBundleProcessor::ClassNameResolver::ResolvedClassName.new('DummyClass'),
                                                                                 XcodeResultBundleProcessor::ClassNameResolver::ResolvedClassName.new('DummyClass')
                                                                             ])
      expect(actual).to eq(%w(deserialized deserialized))
    end

    it 'raises error when encountering invalid token' do
      expect { XcodeResultBundleProcessor::SLF0Deserializer.deserialize_list(['foo']) }.to raise_error('First token should be XcodeResultBundleProcessor::SLF0Tokenizer::ObjectList but was a <foo>')
    end
  end
end