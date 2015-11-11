require "xcoderesultbundleprocessor/version"

module XcodeResultBundleProcessor
  def self.xcactivitylog_to_string(io)
    ret = ''
    Zlib::GzipReader.new(io).each_byte do |byte|
      if byte.chr == "\r"
        ret << "\n"
      else
        ret << byte.chr
      end
    end
    ret
  end
end
