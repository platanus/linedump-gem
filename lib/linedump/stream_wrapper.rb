module Linedump

  class StreamWrapper

    MAX_LENGTH = 2048

    attr_reader :stream

    def initialize(_stream, _block)
      @stream = _stream
      @block = _block
      @buffer = []
      @eof = false
    end

    def eof?
      @eof
    end

    def process_lines
      begin
        loop do
          chunk = @stream.read_nonblock(MAX_LENGTH)
          process_chunk chunk
        end
      rescue IO::WaitReadable
        # nothing, just stop looping
      rescue EOFError, IOError
        @eof = true
      rescue Exception => exc
        puts "Error in stream consumer: #{exc.class}" # TODO: not sure where to send this error
        @eof = true
      end
    end

  private

    def process_chunk(_chunk)
      index = _chunk.index $/

      unless index.nil?
        head = _chunk[0..index-1]
        tail = _chunk[index+1..-1]

        @block.call(@buffer.join + head)
        @buffer.clear

        process_chunk tail
      else
        @buffer << _chunk
      end
    end

  end
end