require 'methadone'
require 'xcoderesultbundleprocessor/version'
require 'xcoderesultbundleprocessor/slf0_tokenizer'
require 'xcoderesultbundleprocessor/class_name_resolver'

module XcodeResultBundleProcessor
  include Methadone::CLILogging

  def self.xcactivitylog_to_string(io)
    io = Zlib::GzipReader.new(io)
    debug "Reading tokens"
    tokens          = SLF0Tokenizer.read_token_stream(io).to_a
    tokens          = ClassNameResolver.resolve_class_names(tokens)
    stringified_log = tokens.find_all do |token|
      if token.is_a?(String)
        newline_idx = token.length
        newline_idx = token.index("\n") if token.include?("\n")
        debug "  String with length #{token.length}: #{token[0...newline_idx]}"
      elsif token.is_a?(ClassNameResolver::ResolvedClassName)
        debug "  Resolved class name #{token.class_name}"
      else
        debug "  #{token.inspect}"
      end

      token.is_a?(String)
    end.join("\n")
    debug "Finished reading tokens"

    stringified_log << "\n" unless stringified_log.end_with?("\n")
    stringified_log
  end
end
