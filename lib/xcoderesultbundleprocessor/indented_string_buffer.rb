module XcodeResultBundleProcessor
  class IndentedStringBuffer
    def initialize(buffer=nil, indent_level=0)
      @buffer        = buffer || ''
      @indent_spaces = 2
      @indent_level  = indent_level
    end

    def <<(arg)
      Array(arg).each do |line|
        @buffer << ' ' * (@indent_spaces * @indent_level) << line
        @buffer << "\n" unless line.end_with?("\n")
        @buffer
      end
      self
    end

    def add_newline
      @buffer << "\n"
      self
    end

    def indent
      IndentedStringBuffer.new(@buffer, @indent_level + 1)
    end

    def to_s
      return "\n" if @buffer.empty?
      @buffer
    end

  end
end