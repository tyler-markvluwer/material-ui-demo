React = require('react')

rouletteView = React.createClass    
    #################################
    #       React Functions
    #################################
    componentDidMount: ->
        @roulette_options = {
            speed : 7
            duration : 3
            stopImageNumber : 1

            # startCallback: () - >
                # console.log('start')
            slowDownCallback: () ->
                console.log('slowDown')
            stopCallback: ($stopElm) =>
                console.log('stop')
                @props.onStop()
        }

        $('div.roulette').roulette(@roulette_options);
        # @props.model.on 'change', @update

    update: ->
        @forceUpdate()

    render: ->
        <div className="roulette" style={'display':'none'}>
            {for tile in @props.model.get_curr_roulette().get_tiles() 
                <img src={tile} />
            }
        </div>

module.exports = React.createFactory(rouletteView)