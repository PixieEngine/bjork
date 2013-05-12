# Bjork

[![Gem Version](https://badge.fury.io/rb/bjork.png)](http://badge.fury.io/rb/bjork)
[![Code Climate](https://codeclimate.com/github/PixieEngine/bjork.png)](https://codeclimate.com/github/PixieEngine/bjork)

[Documentation](http://pixieengine.github.io/bjork/)

Magical HTML local game server. Serves up your CoffeeScript, JavaScript, image and sound assets.

Put your files in:

    data
    images
    sounds
    music
    source

and they will be served by Bjork.

## Installation

    gem install bjork

## Usage

Creating a new game is easy!

    bjork create awesome_game

Start the server and it will serve up your game. On the command line from within your games root directory:

    bjork

This will start the bjork server.

Your game will be accessible at http://localhost:1999

## FAQ

Q. Why no umlaut?

A. Umlauts are hell on Rubygems

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
