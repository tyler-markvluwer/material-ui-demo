EventEmitter = require('events').EventEmitter # used to tell UI when to update
Roulette = require('./roulette')
Globals = require('./globals')

addDemoRoulettes = () ->
    rouls = []

    mario = new Roulette('mario')
    mario.add_tile('star', 'star.png')
    mario.add_tile('flower', 'flower.png')
    mario.add_tile('coin', 'coin.png')
    mario.add_tile('mushroom', 'mshroom.png')
    mario.add_tile('chompy', 'chomp.png')
    mario.add_tile('random', 'random.png')
    rouls.push mario

    bars = new Roulette('bars')
    bars.add_tile('Ricks', 'ricks.jpeg')
    bars.add_tile('Ashleys', 'ashleys.jpeg')
    bars.add_tile('Skeeps', 'skeeps.jpeg')
    rouls.push bars

    return rouls

class Model extends EventEmitter
    constructor: (@app_name, @app_desc) ->
        @rouls = []

        for roul in addDemoRoulettes()
            @add_roulette(roul)

        @set_curr_roulette('bars')
        @main_title = "Shuffle-It"
        @curr_view = "SPINNER_NEW"

    get_curr_view: () ->
        return @curr_view

    get_main_title: () ->
        return @main_title

    set_main_title: (new_title) ->
        @main_title = new_title

    set_cur_view: (new_view) ->
        @curr_view = new_view
        @emit 'change'

    add_roulette: (roul) ->
        @rouls.push roul
        last = @rouls[-1..][0]
        console.log last.name
        last.on 'toggle', @toggle_emit

    toggle_emit: () ->
        console.log 'force emitting'
        @emit 'toggle'

    get_curr_roulette: () ->
        return @curr_roul

    set_curr_roulette: (name) => #REQUIRED to pass correct context of 'this' into function
        @curr_roul = @find_roulette(name)
        @emit 'change'

    get_roulettes: () ->
        return @rouls

    find_roulette: (name) ->
        for roul in @rouls
            if roul.name == name
                return roul

    

module.exports = Model # Don't forget to export!!!