
class Roulette
	constructor: (@name) ->
		@tiles = []
		
	add_tile: (tile) ->
		@tiles.push tile

	remove_tile: (index) ->

	get_tiles: () ->
		return @tiles

module.exports = Roulette