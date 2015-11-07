#!/bin/bash
# Pre reqs
# 1. Must have homebrew installed
# 2. Must have xcode and xcode command line tools installed
# 3. ???
# 4. must have javac installed (built in for mac)
# 5. must have sublime package installer installed

# install node
brew update # okay if this fails
brew install node # don't use sudo on brew commands

# install npm
# donwload from nodejs site. This is the easiest way
brew install npm

# install cordova
#npm install -g cordova

# install ant
brew install ant

# install broccoli
npm install --save-dev broccoli
npm install -g broccoli-cli
#npm install -g broccoli-cli
#npm install -g broccoli-coffee
npm install # install all packages specific to this project

# install the coffeescript syntax highlighter for sublime
# 1. cmd + shift + p
# 2. install, then press enter
# 3. search 'BetterCoffeeScript'
# 4. Press enter
