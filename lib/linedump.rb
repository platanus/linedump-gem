require "linedump/version"
require "linedump/consumer"

module Linedump

  def self.consumer
    @@consumer ||= Consumer.new
  end

  def self.each_line(_stream, &_block)
    consumer.register_stream _stream, &_block
    consumer.reload
    nil
  end

end