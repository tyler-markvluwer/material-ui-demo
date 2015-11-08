EventEmitter = require('events').EventEmitter # used to tell UI when to update

class Tile extends EventEmitter
    constructor: (@text, @img) ->
        @active = true

    toggleActive: () =>
        if @active
            @active = false
        else
            @active = true

        window.model.emit 'change'

module.exports = Tile
