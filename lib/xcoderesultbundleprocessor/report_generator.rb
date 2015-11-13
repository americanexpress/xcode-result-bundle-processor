require 'rubygems/package'
require 'methadone'
require 'plist4r'
require 'awesome_print'


module XcodeResultBundleProcessor
  module ReportGenerator
    include Methadone::CLILogging

    def self.generate_report(results_bundle_path)
      info "Preparing report for results bundle path at #{results_bundle_path}"


      results_bundle = if File.directory?(results_bundle_path)
                         DirectoryResultsBundle.new(results_bundle_path)
                       else
                         TarballResultsBundle.new(results_bundle_path)
                       end

      plist = results_bundle.read_plist('Info.plist')

      plist.Actions.each do |action|
        log_pathname = action['ActionResult']['LogPath']
        results_bundle.open_file(log_pathname) do |activity_log_io|
          io     = Zlib::GzipReader.new(activity_log_io)
          tokens = SLF0::Tokenizer.read_token_stream(io)
          tokens = SLF0::ClassNameResolver.resolve_class_names(tokens).to_a

          # SLF0 files have a random int at the beginning; don't know its significance
          tokens.shift

          section = SLF0::Deserializer.deserialize(tokens)
          debug section.ai

          info ActivityLogFormatter.format(section.subsections.first)
        end
      end


    end

    private

    class DirectoryResultsBundle
      def initialize(path)
        @path = Pathname.new(path)
      end

      def read_plist(path)
        Plist4r.open(@path.join(path).to_s)
      end

      def open_file(path, &block)
        File.open(@path.join(path), &block)
      end
    end

    class TarballResultsBundle
      def initialize(path)
        file = File.new(path)
        zip  = Zlib::GzipReader.new(file)
        @tar = Gem::Package::TarReader.new(zip)
      end

      def read_plist(path)
        @tar.seek("./#{path}") do |plist_entry|
          plist_entry.read.to_plist
        end
      end

      def open_file(path, &block)
        @tar.seek("./#{path}", &block)
      end
    end
  end
end