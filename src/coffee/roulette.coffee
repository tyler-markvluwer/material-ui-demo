Tile = require('./tile')
EventEmitter = require('events').EventEmitter # used to tell UI when to update


class Roulette extends EventEmitter
    constructor: (@name) ->
        @tiles = []

    force_emit: () ->
        console.log 'roulette force emit'
        @emit 'toggle'

    add_tile: (text, img) ->
        tile = new Tile(text, img)
        @tiles.push tile
        tile.on 'tile-toggle', @force_emit

    cover_photo_url: () ->
        return @tiles[0].img

    remove_tile: (index) ->

    get_tiles: () ->
        return @tiles

    get_active_tiles: () ->
        return (tile for tile in @tiles when tile.active)

    get_inactive_tiles: () ->
        return (tile for tile in @tiles when not tile.active)

module.exports = Roulette