React = require('react')

{AppBar, FlatButton, GridList, GridTile, IconButton, Paper} = require('material-ui')
StarBorder = require('material-ui/lib/svg-icons/toggle/star-border')
AddCircle = require('material-ui/lib/svg-icons/content/add')
IconMenu = require('material-ui/lib/menus/icon-menu')
MenuItem = require('material-ui/lib/menus/menu-item')
MoreVertIcon = require('material-ui/lib/svg-icons/navigation/more-vert')
Colors = require('material-ui/lib/styles/colors')

iconButtonElement = (
  <IconButton
    touch={true}
    tooltip="more"
    tooltipPosition="bottom-right">
    <MoreVertIcon color={"white"} />
  </IconButton>
)

spinnerTileView = React.createClass    
    #################################
    #       React Functions
    #################################
    componentDidMount: ->
        @props.model.on 'change', @update

    update: ->
        @forceUpdate()

    getInitialState: ->
        {
            curr_roul: null
        }

    updateCurrRoul: (name) ->
        console.log "curr_roul: " + name
        @setState({curr_roul: name})

    activateRoulette: (name) ->
        @props.model.set_curr_roulette(name)
        @props.model.set_cur_view("SPINNER_MAIN")

    addSpinner: () ->
        @props.model.set_cur_view("SPINNER_NEW")

    _menuItemTouchTap: (event, value) ->

        switch value
            when 'ShuffleIt'
                @props.model.set_curr_roulette(@state.curr_roul)
                @props.model.set_cur_view("SPINNER_MAIN")
            when 'Edit Spinner'
                @props.model.set_curr_roulette(@state.curr_roul)
                @props.model.set_cur_view("SPINNER_EDIT")


    render: ->
        PlusButton = (<IconButton onClick={@addSpinner}><AddCircle /></IconButton>)
        rightIconMenu = (
            <IconMenu iconButtonElement={iconButtonElement} onChange={@_menuItemTouchTap} openDirection = "top-left">
                <MenuItem value='ShuffleIt'>ShuffleIt</MenuItem>
                <MenuItem value='Edit Spinner'>Edit Spinner</MenuItem>
            </IconMenu>
        )
        <div>
            <AppBar
                title='All Spinners'
                iconElementRight={PlusButton}
                onLeftIconButtonTouchTap={@props.toggleLeft}
            />

            {if @props.model.get_roulettes().length
                <GridList 
                    cellHeight={200}
                    style={{width: '100%', overflowY: 'auto', marginLeft: '0px'}}
                >
                {for roul in @props.model.get_roulettes()
                    <GridTile
                        title={roul.name}
                        subtitle={<span>by <b>demo user</b></span>}
                        actionIcon={rightIconMenu}
                        onClick={@updateCurrRoul.bind(this, roul.name)}
                    >
                        <img src={roul.cover_photo_url()} />
                    </GridTile>
                }
                </GridList>
            else
                <div className='container' style={width: '100%'}>
                    <div className='row'>
                        <div className='col-sm-1'></div>
                        <div className='col-sm-10'>
                            <Paper zDepth={2}>
                                <h3 style={padding: '6%'}>
                                    You have no Spinners at this time! Try making some by clicking the '+'
                                    button at the top!
                                </h3>
                            </Paper>
                        </div>
                        <div className='col-sm-1'></div>
                    </div>
                </div>
            }
        </div>

module.exports = React.createFactory(spinnerTileView)
