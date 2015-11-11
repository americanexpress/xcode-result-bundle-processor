require "xcoderesultbundleprocessor/version"
require "xcoderesultbundleprocessor/slf0_tokenizer"

module XcodeResultBundleProcessor
  def self.xcactivitylog_to_string(io)
    io              = Zlib::GzipReader.new(io)
    stringified_log = SLF0Tokenizer.read_token_stream(io).find_all { |token| token.is_a?(String) }.join("\n")
    stringified_log << "\n" unless stringified_log.end_with?("\n")
    stringified_log
  end
end
