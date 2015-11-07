EventEmitter = require('events').EventEmitter # used to tell UI when to update
Roulette = require('./roulette')
Globals = require('./globals')

addDemoRoulettes = () ->
    rouls = []

    mario = new Roulette('mario')
    mario.add_tile('star.png')
    mario.add_tile('flower.png')
    mario.add_tile('coin.png')
    mario.add_tile('mshroom.png')
    mario.add_tile('chomp.png')
    mario.add_tile('random.png')
    rouls.push mario

    bars = new Roulette('bars')
    bars.add_tile('ricks.jpeg')
    bars.add_tile('ashleys.jpeg')
    bars.add_tile('skeeps.jpeg')
    rouls.push bars

    return rouls

class Model extends EventEmitter
    constructor: (@app_name, @app_desc) ->
        # @rouls = [] TODO: restore old version here
        @rouls = addDemoRoulettes()
        @set_curr_roulette('bars')
        @curr_view = "SPINNER_MAIN"

    get_curr_view: () ->
        return @curr_view

    set_cur_view: (new_view) ->
        console.log "new view set: " + new_view
        @curr_view = new_view
        @emit 'change'

    add_roulette: (roul) ->
        @rouls.push roul

    get_curr_roulette: () ->
        return @curr_roul

    get_roulettes: () ->
        return @rouls

    find_roulette: (name) ->
        for roul in @rouls
            if roul.name == name
                return roul

    set_curr_roulette: (name) => #REQUIRED to pass correct context of 'this' into function
        @curr_roul = @find_roulette(name)
        @emit 'change'

    

module.exports = Model # Don't forget to export!!!