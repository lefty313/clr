# Clr

This gem helps you to manage common debugging markes such as 'binding.pry', 'debugger' etc.

In this video you can see how it works http://www.youtube.com/watch?v=yd9kQEYALTc&hd=1

## Installation

Add this line to your application's Gemfile:

    gem 'clr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clr

## Usage
```shell
  clr clean [PATH || Dir.pwd]

  Options:
    -c, [--comment]    # comment all markers
    -u, [--uncomment]  # uncomment all markers
    -r, [--remove]     # remove all markers
    -s, [--search]     # search markers
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
