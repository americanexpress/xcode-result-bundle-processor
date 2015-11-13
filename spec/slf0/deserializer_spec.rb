module XcodeResultBundleProcessor
  module SLF0

    describe Deserializer do
      describe '#deserialize' do
        it 'deserializes the given slf0 token stream' do

          module Model
            class DummyClass
              def self.deserialize(tokens)
                'deserialized'
              end
            end
          end

          actual = Deserializer.deserialize([ClassNameResolver::ResolvedClassName.new('DummyClass')])

          expect(actual).to eq('deserialized')
        end

        it 'returns nil for nil' do
          actual = Deserializer.deserialize([nil])

          expect(actual).to be_nil
        end

        it 'raises error when encountering unsupported class type' do
          expect { Deserializer.deserialize([ClassNameResolver::ResolvedClassName.new('InvalidClass')]) }.to raise_error('Unsupported class InvalidClass')
        end

        it 'raises error when first token is not resolved class' do
          expect { Deserializer.deserialize(['foo']) }.to raise_error("First token should be #{ClassNameResolver::ResolvedClassName} but was a <foo>")
        end
      end

      describe '#deserialize_list' do
        it 'treats nil as empty array' do
          actual = Deserializer.deserialize_list([nil])
          expect(actual).to eq([])
        end

        it 'deserializes a list' do
          actual = Deserializer.deserialize_list([
                                                     Tokenizer::ObjectList.new(2),
                                                     ClassNameResolver::ResolvedClassName.new('DummyClass'),
                                                     ClassNameResolver::ResolvedClassName.new('DummyClass')
                                                 ])
          expect(actual).to eq(%w(deserialized deserialized))
        end

        it 'raises error when encountering invalid token' do
          expect { Deserializer.deserialize_list(['foo']) }.to raise_error("First token should be #{Tokenizer::ObjectList} but was a <foo>")
        end
      end
    end
  end
end