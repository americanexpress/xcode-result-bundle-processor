module XcodeResultBundleProcessor
  module SLF0
    module Tokenizer
      Token                = Struct.new(:int, :identifier)
      ClassName            = Struct.new(:class_name)
      ClassNameRef         = Struct.new(:class_name_id)
      ObjectList           = Struct.new(:mystery_number)
      TOKEN_INT            = '#'
      TOKEN_CLASS_NAME     = '%'
      TOKEN_CLASS_NAME_REF = '@'
      TOKEN_STRING         = '"'
      TOKEN_DOUBLE         = '^'
      OBJECT_LIST_NIL      = '-'
      OBJECT_LIST          = '('

      def self.read_token_stream(io)
        raise 'Not an SLF0 file' unless self.valid_slf0_io?(io)

        Enumerator.new do |enumerator|
          until io.eof?
            token = self.read_length_and_token_type(io)

            case token.identifier
              when TOKEN_INT
                enumerator.yield(token.int)
              when TOKEN_DOUBLE
                enumerator.yield(token.int)
              when TOKEN_STRING
                enumerator.yield(io.read(token.int).gsub("\r", "\n"))
              when TOKEN_CLASS_NAME
                enumerator.yield(ClassName.new(io.read(token.int)))
              when TOKEN_CLASS_NAME_REF
                enumerator.yield(ClassNameRef.new(token.int))
              when OBJECT_LIST
                enumerator.yield(ObjectList.new(token.int))
              when OBJECT_LIST_NIL
                enumerator.yield(nil)
              else
                enumerator.yield(token)
            end

          end
        end
      end

      def self.valid_slf0_io?(io)
        return false if io.nil?
        io.read(4) == 'SLF0'
      end

      def self.read_length_and_token_type(io)
        # The length appears as the start of the token as 0 or more ASCII decimal or hex digits until the token type marker
        length_string = ''
        until [TOKEN_INT, TOKEN_CLASS_NAME, TOKEN_CLASS_NAME_REF, TOKEN_STRING, TOKEN_DOUBLE, OBJECT_LIST_NIL, OBJECT_LIST].include?((c = io.readchar)) do
          length_string << c
        end

        token = c

        # TODO: Doubles are stored as hex strings. If it turns out the doubles contain useful information, implement
        # logic to convert the hex string to doubles
        if token == TOKEN_DOUBLE
          length_string = ''
        end

        return Token.new(length_string.to_i, c)
      end

      private

      def self._read_length_for_token(io, token_identifier)
        # The length is an ASCII decimal string possibly preceded by dashes
        length_string = ''
        while (c = io.readchar) != token_identifier do
          length_string << c unless c == '-' # Some strings lengths are preceded by 1 or more dashes, which we want to skip
        end

        length_string.to_i
      end
    end
  end
end
