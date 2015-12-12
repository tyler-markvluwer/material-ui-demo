Tile = require('./tile')
EventEmitter = require('events').EventEmitter # used to tell UI when to update


class Roulette extends EventEmitter
    constructor: (@name) ->
        @tiles = []
        @img = ''

    force_emit: () ->
        @emit 'toggle'

    add_tile: (text, img) ->
        tile = new Tile(text, img)
        @tiles.push tile
        tile.on 'tile-toggle', @force_emit

    cover_photo_url: () ->
        if @img.length
            return @img
        if @tiles.length
            return @tiles[0].img
        else
            return ''

    remove_tile: (text) ->
        @tiles = (tile for tile in @tiles when tile.text != text)

    disable_tile: (text) ->
        (tile.toggleActive() for tile in @tiles when tile.text == text)

    get_tiles: () ->
        return @tiles

    get_active_tiles: () ->
        return (tile for tile in @tiles when tile.active)

    get_inactive_tiles: () ->
        return (tile for tile in @tiles when not tile.active)

module.exports = Roulette