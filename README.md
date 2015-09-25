# Linedump

Linedump provides a safe way of listening data from output streams. It's intended to be used to listen for child processes output.

## Installation

Add this line to your application's Gemfile:

    gem 'linedump'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install linedump

## Usage

Usage is as simple as doing

```ruby
stdin, stdout, wait_thr = Open3.popen('somebin')

Linedump.each_line stdout do |line|
  # this will be called in a separate listening thread.
  logger.log(line)
end

# do something with the process...
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cangrejo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
