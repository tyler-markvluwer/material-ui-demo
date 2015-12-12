React = require('react')

{AppBar, FlatButton, GridList, GridTile, IconButton, Paper} = require('material-ui')
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
        PlusButton = (<IconButton onClick={@addSpinner}><AddCircle /></IconButton>)

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
                        actionIcon={<IconButton><StarBorder color="white"/></IconButton>}
                        onClick={@activateRoulette.bind(this, roul.name)}
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