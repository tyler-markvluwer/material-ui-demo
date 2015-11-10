React = require('react')
PlusButton = require('./plusButton')

{AppBar, FlatButton, GridList, GridTile, IconButton} = require('material-ui')
StarBorder = require('material-ui/lib/svg-icons/toggle/star-border')
AddCircle = require('material-ui/lib/svg-icons/content/add')

spinnerTileView = React.createClass    
    #################################
    #       React Functions
    #################################
    componentDidMount: ->
        @props.model.on 'change', @update

    update: ->
        @forceUpdate()

    activateRoulette: (name) ->
        @props.model.set_curr_roulette(name)
        @props.model.set_cur_view("SPINNER_MAIN")

    addSpinner: () ->
        @props.model.set_cur_view("SPINNER_NEW")

    render: ->
        <div>
            
            <AppBar
                title='All Spinners'
                iconElementRight={<PlusButton click={@addSpinner} />}
                onLeftIconButtonTouchTap={@props.toggleLeft}
            />
            <br />

            <GridList
                cellHeight={200}
                style={{width: '100.%', height: 410, overflowY: 'auto'}}
            >
            {for roul in @props.model.get_roulettes()
                <GridTile
                    title={roul.name}
                    subtitle={<span>by <b>author_here</b></span>}
                    actionIcon={<IconButton><StarBorder color="white"/></IconButton>}
                    onClick={@activateRoulette.bind(this, roul.name)}
                >
                <img src={roul.cover_photo_url()} /></GridTile>
            }
            </GridList>
        </div>

module.exports = React.createFactory(spinnerTileView)