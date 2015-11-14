module XcodeResultBundleProcessor
  describe IndentedStringBuffer do
    describe '#add_line' do
      it 'adds line with indentation' do
        buffer = IndentedStringBuffer.new
        actual = buffer.add_line("Foo\n", 1)
        expect(actual).to eq("  Foo\n")
      end

      it 'raises for negative indentation' do
        expect { IndentedStringBuffer.new.add_line('Foo', -1) }.to raise_error('Invalid indentation level: -1')
      end

      it 'appends newline if missing' do
        buffer = IndentedStringBuffer.new
        actual = buffer.add_line('Foo', 1)
        expect(actual).to eq("  Foo\n")
      end
    end

    describe '#add_lines' do
      it 'adds multiple lines' do
        buffer = IndentedStringBuffer.new
        actual = buffer.add_lines(%W(Foo\n Bar\n), 1)
        expect(actual).to eq("  Foo\n  Bar\n")
      end

      it 'adds missing newlines' do
        buffer = IndentedStringBuffer.new
        actual = buffer.add_lines(%w(Foo Bar), 1)
        expect(actual).to eq("  Foo\n  Bar\n")
      end
    end

    describe '#add_newline' do
      it 'adds newline' do
        buffer = IndentedStringBuffer.new
        actual = buffer.add_newline
        expect(actual).to eq("\n")
      end
    end

    describe '#to_s' do
      it 'converts to string' do
        buffer = IndentedStringBuffer.new
        buffer.add_line("Foo\n", 1)
        expect(buffer.to_s).to eq("  Foo\n")
      end

      it 'returns newline for blank string' do
        expect(IndentedStringBuffer.new.to_s).to eq("\n")
      end

    end
  end
end