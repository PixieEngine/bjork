# Bjork

Magical HTML local game server. Serves up your CoffeeScript, JavaScript, image and sound assets.

Put your files in:

    data
    images
    sounds
    music
    source

and they will be served by Bjork.

## Installation

Add this line to your application's Gemfile:

    gem 'bjork'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bjork

## Usage

Start the server and it will serve up your game. In your Rakefile

    require "bjork/tasks"

Then on the command line

    rake start

This will start the bjork server.

Your game will be accessible at http://localhost:4567

## FAQ

Q. Why no umlaut?

A. Umlauts are hell on Rubygems

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
