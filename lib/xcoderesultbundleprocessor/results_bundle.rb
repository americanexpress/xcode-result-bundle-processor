require 'rubygems/package'
require 'methadone'
require 'plist4r'
require 'awesome_print'

module XcodeResultBundleProcessor
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
