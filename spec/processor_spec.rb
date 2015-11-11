require 'xcoderesultbundleprocessor/processor.rb'

RSpec.describe XcodeResultBundleProcessor, '#xcactivitylog_to_string' do
  it 'gunzips the provided string' do
    string = "I'm a pretend log statement that logs things"

    XcodeResultBundleProcessor.xcactivitylog_to_string(gzip_string(string)).should == string
  end

  it 'converts mac newlines to regular newlines' do
    string = "One line\rTwo line"

    XcodeResultBundleProcessor.xcactivitylog_to_string(gzip_string(string)).should == "One line\nTwo line"
  end

  def gzip_string(string)
    compressed  = StringIO.new('w')
    gzip_writer = Zlib::GzipWriter.new(compressed)
    gzip_writer.write(string)
    gzip_writer.close

    StringIO.new(compressed.string, 'rb')
  end
end
