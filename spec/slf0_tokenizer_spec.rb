require 'xcoderesultbundleprocessor/slf0_tokenizer.rb'

RSpec.describe XcodeResultBundleProcessor::SLF0Tokenizer do
  describe '#valid_slf0_io?' do
    it 'returns false for nil' do
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.valid_slf0_io?(nil)).to be_falsey
    end

    it 'returns false for empty string' do
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.valid_slf0_io?(StringIO.new(''))).to be_falsey
    end

    it 'returns false for garbage string' do
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.valid_slf0_io?(StringIO.new('not a thing'))).to be_falsey
    end

    it 'returns true if correct header present' do
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.valid_slf0_io?(StringIO.new('SLF0'))).to be_truthy
    end
  end

  describe '#read_length_and_token_type' do
    it 'can read int' do
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.read_length_and_token_type(StringIO.new('7#'))).to eq(XcodeResultBundleProcessor::SLF0Tokenizer::Token.new(7, XcodeResultBundleProcessor::SLF0Tokenizer::TOKEN_INT))
    end

    it 'can read class name' do
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.read_length_and_token_type(StringIO.new('13%'))).to eq(XcodeResultBundleProcessor::SLF0Tokenizer::Token.new(13, XcodeResultBundleProcessor::SLF0Tokenizer::TOKEN_CLASS_NAME))
    end

    it 'can read class name ref' do
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.read_length_and_token_type(StringIO.new('1@'))).to eq(XcodeResultBundleProcessor::SLF0Tokenizer::Token.new(1, XcodeResultBundleProcessor::SLF0Tokenizer::TOKEN_CLASS_NAME_REF))
    end

    it 'can read string' do
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.read_length_and_token_type(StringIO.new('1234"'))).to eq(XcodeResultBundleProcessor::SLF0Tokenizer::Token.new(1234, XcodeResultBundleProcessor::SLF0Tokenizer::TOKEN_STRING))
    end

    it 'can read object list' do
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.read_length_and_token_type(StringIO.new('5('))).to eq(XcodeResultBundleProcessor::SLF0Tokenizer::Token.new(5, XcodeResultBundleProcessor::SLF0Tokenizer::OBJECT_LIST))
    end

    it 'can read object list nil' do
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.read_length_and_token_type(StringIO.new('-'))).to eq(XcodeResultBundleProcessor::SLF0Tokenizer::Token.new(0, XcodeResultBundleProcessor::SLF0Tokenizer::OBJECT_LIST_NIL))
    end

    it 'can read double' do
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.read_length_and_token_type(StringIO.new('394498f8a1f2bb41^'))).to eq(XcodeResultBundleProcessor::SLF0Tokenizer::Token.new(0, XcodeResultBundleProcessor::SLF0Tokenizer::TOKEN_DOUBLE))
    end

    it 'errors if reading something that is not a token' do
      expect { XcodeResultBundleProcessor::SLF0Tokenizer.read_length_and_token_type(StringIO.new('lalalalalalalalalala')) }.to raise_error(EOFError)
    end
  end

  describe '#read_token_stream' do
    it 'errors for invalid file' do
      expect { XcodeResultBundleProcessor::SLF0Tokenizer.read_token_stream(StringIO.new('butter')).to_a }.to raise_error('Not an SLF0 file')
    end

    it 'reads an empty file' do
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.read_token_stream(StringIO.new('SLF0')).to_a).to be_empty
    end

    it 'reads a simple file' do
      input_file      = 'SLF07#21%IDEActivityLogSection1@0#31"com.apple.dt.unit.cocoaUnitTest'
      expected_tokens = [
          7,
          XcodeResultBundleProcessor::SLF0Tokenizer::ClassName.new('IDEActivityLogSection'),
          XcodeResultBundleProcessor::SLF0Tokenizer::ClassNameRef.new(1),
          0,
          'com.apple.dt.unit.cocoaUnitTest',
      ]

      expect(XcodeResultBundleProcessor::SLF0Tokenizer.read_token_stream(StringIO.new(input_file)).to_a).to eq(expected_tokens)
    end

    it 'reads a file with double' do
      input_file      = 'SLF05da8acc0a1f2bb41^'
      expected_tokens = [
          0
      ]
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.read_token_stream(StringIO.new(input_file)).to_a).to eq(expected_tokens)
    end

    it 'reads a file with object list' do
      input_file      = 'SLF01(2@3#---'
      expected_tokens = [
          XcodeResultBundleProcessor::SLF0Tokenizer::ObjectList.new(1),
          XcodeResultBundleProcessor::SLF0Tokenizer::ClassNameRef.new(2),
          3,
          nil,
          nil,
          nil,

      ]
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.read_token_stream(StringIO.new(input_file)).to_a).to eq(expected_tokens)
    end

    it 'converts newlines in strings' do
      input_file      = "SLF08\"O\rne\rTwo"
      expected_tokens = [
          "O\nne\nTwo"
      ]
      expect(XcodeResultBundleProcessor::SLF0Tokenizer.read_token_stream(StringIO.new(input_file)).to_a).to eq(expected_tokens)
    end
  end
end
