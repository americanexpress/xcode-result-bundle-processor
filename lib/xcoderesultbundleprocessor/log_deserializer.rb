require 'rubygems/package'
require 'methadone'
require 'plist4r'
require 'awesome_print'


module XcodeResultBundleProcessor
  module LogDeserializer
    include Methadone::CLILogging

    def self.deserialize_action_logs(results_bundle)

      plist = results_bundle.read_plist('Info.plist')

      action       = plist.Actions.first
      log_pathname = action['ActionResult']['LogPath']
      results_bundle.open_file(log_pathname) do |activity_log_io|
        io     = Zlib::GzipReader.new(activity_log_io)
        tokens = SLF0::Tokenizer.read_token_stream(io)
        tokens = SLF0::ClassNameResolver.resolve_class_names(tokens).to_a

        # SLF0 files have a random int at the beginning; don't know its significance
        tokens.shift

        section = SLF0::Deserializer.deserialize(tokens)
        debug section.ai

        ActivityLogFormatter.format(section.subsections.first)
      end
    end
  end
end