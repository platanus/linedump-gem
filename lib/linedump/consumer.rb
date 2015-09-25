require "thwait"
require "linedump/stream_wrapper"

module Linedump

  class Consumer

    class StopSignal < Exception; end

    class ReloadSignal < Exception; end

    def initialize
      @streams = []
      @lock = Mutex.new
      @worker = nil
    end

    def register_stream(_stream, &_block)
      # TODO: locking for non-GIL platforms
      @streams << StreamWrapper.new(_stream, _block)
    end

    def is_registered?(_stream)
      not find_stream_wrapper(_stream).nil?
    end

    def reload
      @lock.synchronize do
        if @worker and @worker.alive?
          @worker.raise ReloadSignal # signal worker to reload streams
        else
          @worker = load_worker
        end
      end
    end

    def stop
      @lock.synchronize do
        if @worker and @worker.alive?
          @worker.raise StopSignal
        end
      end
    end

  private

    def load_worker
      Thread.new do
        looped = 0
        begin
          while @streams.count > 0
            read_streams = load_monitored_streams
            result = IO.select(read_streams, [], read_streams)
            if result
              process_ready_streams result[0]
              discard_errored_streams result[2]
            end
            looped += 1
          end
        rescue ReloadSignal
          retry
        rescue StopSignal, SystemExit
          # nothing
        end
      end
    end

    def process_ready_streams(_streams)
      _streams.each do |stream|
        wrapper = find_stream_wrapper stream
        if wrapper
          wrapper.process_lines
          remove_wrapper wrapper, :eof if wrapper.eof?
        end
      end
    end

    def discard_errored_streams(_streams)
      _streams.each do |stream|
        wrapper = find_stream_wrapper stream
        remove_wrapper wrapper, :error if wrapper
      end
    end

    def find_stream_wrapper(_stream)
      @streams.find { |s| s.stream == _stream }
    end

    def remove_wrapper(_wrapper, _reason)
      # TODO: locking for non-GIL platforms
      @streams.delete _wrapper
    end

    def load_monitored_streams
      # include stdin to prevent console enabled apps from locking
      @streams.map(&:stream) << $stdin
    end

  end

end