module XcodeResultBundleProcessor
  describe IndentedStringBuffer do
    describe '#<<' do
      it 'adds line' do
        buffer = IndentedStringBuffer.new
        buffer << "Foo\n"
        expect(buffer.to_s).to eq("Foo\n")
      end

      it 'appends newline if missing' do
        buffer = IndentedStringBuffer.new
        buffer << 'Foo'
        expect(buffer.to_s).to eq("Foo\n")
      end

      it 'adds multiple lines' do
        buffer = IndentedStringBuffer.new
        buffer << %W(Foo\n Bar\n)
        expect(buffer.to_s).to eq("Foo\nBar\n")
      end

      it 'adds missing newlines' do
        buffer = IndentedStringBuffer.new
        buffer << %w(Foo Bar)
        expect(buffer.to_s).to eq("Foo\nBar\n")
      end

      it 'allows chaining' do
        buffer = IndentedStringBuffer.new
        buffer << 'one' << 'two'
        expect(buffer.to_s).to eq("one\ntwo\n")
      end

    end

    describe '#add_newline' do
      it 'adds newline' do
        buffer = IndentedStringBuffer.new
        buffer.add_newline
        expect(buffer.to_s).to eq("\n")
      end

      it 'returns buffer' do
        buffer = IndentedStringBuffer.new
        expect(buffer.add_newline).to eq(buffer)
      end
    end

    describe '#to_s' do
      it 'converts to string' do
        buffer = IndentedStringBuffer.new
        buffer << "Foo\n"
        expect(buffer.to_s).to eq("Foo\n")
      end

      it 'returns newline for blank string' do
        expect(IndentedStringBuffer.new.to_s).to eq("\n")
      end
    end

    describe '#indent' do
      it 'allows indenting' do
        buffer = IndentedStringBuffer.new
        buffer.indent << 'Indented Line'
        expect(buffer.to_s).to eq("  Indented Line\n")
      end
    end
  end
end