require 'methadone'
require 'xcoderesultbundleprocessor/version'
require 'xcoderesultbundleprocessor/slf0_tokenizer'

module XcodeResultBundleProcessor
  include Methadone::CLILogging

  def self.xcactivitylog_to_string(io)
    io = Zlib::GzipReader.new(io)
    debug "Reading tokens"
    stringified_log = SLF0Tokenizer.read_token_stream(io).find_all do |token|
      token_representation = token.inspect
      if token.is_a?(String)
        token_representation = "String with length #{token.length}"
      end
      debug "  #{token_representation}"

      token.is_a?(String)
    end.join("\n")
    debug "Finished reading tokens"

    stringified_log << "\n" unless stringified_log.end_with?("\n")
    stringified_log
  end
end
