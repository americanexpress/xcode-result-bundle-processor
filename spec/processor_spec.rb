require 'xcoderesultbundleprocessor/processor.rb'

RSpec.describe XcodeResultBundleProcessor, '#xcactivitylog_to_string' do
  it 'converts the given SLF0 file' do
    string = "SLF04\"Foo\n"

    expect(XcodeResultBundleProcessor.xcactivitylog_to_string(gzip_string(string))).to eq("Foo\n")
  end

  it 'appends a newline if no trailing newline' do
    string = "SLF04\"Foo"

    expect(XcodeResultBundleProcessor.xcactivitylog_to_string(gzip_string(string))).to eq("Foo\n")
  end

  def gzip_string(string)
    compressed  = StringIO.new('w')
    gzip_writer = Zlib::GzipWriter.new(compressed)
    gzip_writer.write(string)
    gzip_writer.close

    StringIO.new(compressed.string, 'rb')
  end
end
