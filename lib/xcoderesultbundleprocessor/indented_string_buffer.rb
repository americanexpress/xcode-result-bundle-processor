module XcodeResultBundleProcessor
  class IndentedStringBuffer
    def initialize
      @buffer        = ''
      @indent_spaces = 2
    end

    def add_line(line, indent)
      raise "Invalid indentation level: #{indent}" if indent < 0

      @buffer << ' ' * (@indent_spaces * indent) << line
      @buffer << "\n" unless line.end_with?("\n")
      @buffer
    end

    def add_lines(lines, indent)
      lines.each { |line| self.add_line(line, indent) }
      @buffer
    end

    def add_newline
      @buffer << "\n"
    end

    def to_s
      return "\n" if @buffer.empty?
      @buffer
    end

  end
end