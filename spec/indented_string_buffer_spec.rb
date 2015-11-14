module XcodeResultBundleProcessor
  describe IndentedStringBuffer do
    describe '#add_line' do
      it 'adds line' do
        buffer = IndentedStringBuffer.new
        actual = buffer.add_line("Foo\n")
        expect(actual).to eq("Foo\n")
      end

      it 'appends newline if missing' do
        buffer = IndentedStringBuffer.new
        actual = buffer.add_line('Foo')
        expect(actual).to eq("Foo\n")
      end
    end

    describe '#add_lines' do
      it 'adds multiple lines' do
        buffer = IndentedStringBuffer.new
        actual = buffer.add_lines(%W(Foo\n Bar\n))
        expect(actual).to eq("Foo\nBar\n")
      end

      it 'adds missing newlines' do
        buffer = IndentedStringBuffer.new
        actual = buffer.add_lines(%w(Foo Bar))
        expect(actual).to eq("Foo\nBar\n")
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
        buffer.add_line("Foo\n")
        expect(buffer.to_s).to eq("Foo\n")
      end

      it 'returns newline for blank string' do
        expect(IndentedStringBuffer.new.to_s).to eq("\n")
      end
    end

    describe '#indent' do
      it 'allows indenting' do
        buffer = IndentedStringBuffer.new
        buffer.indent.add_line('Indented Line')
        expect(buffer.to_s).to eq("  Indented Line\n")
      end
    end
  end
end