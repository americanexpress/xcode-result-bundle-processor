module XcodeResultBundleProcessor
  class DirectoryResultsBundle
    def initialize(path)
      @path = Pathname.new(path)
    end

    def read_plist(path)
      CFPropertyList.native_types(CFPropertyList::List.new(file: @path.join(path)).value)
    end

    def open_file(path, &block)
      File.open(@path.join(path), &block)
    end

    def copy_file(source, destination)
      FileUtils.copy(@path.join(source), destination)
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
        CFPropertyList.native_types(CFPropertyList::List.new(data: plist_entry.read).value)
      end
    end

    def open_file(path, &block)
      @tar.seek("./#{path}", &block)
    end

    def copy_file(source, destination)
      @tar.seek("./#{source}") do |source_entry|
        File.open(destination, 'w') do |destination_file|
          destination_file.write(source_entry.read)
        end
      end
    end
  end
end
