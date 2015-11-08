React = require('react')
RouletteView = require('./rouletteView')
{AppBar, FlatButton, RaisedButton, ListDivider, List, ListItem, IconButton, Snackbar} = require('material-ui')
AddCircle = require('material-ui/lib/svg-icons/content/add')


defaultPageView = React.createClass    
    #################################
    #       React Functions
    #################################
    componentDidMount: ->
        @props.model.on 'change', @update

    update: ->
        @forceUpdate()

    spinRoulette: ->
        $('div.roulette').roulette('start')

    showSnack: ->
        @props.snack_show()

    render: ->
        <div>
            <AppBar
                title="Shuffle-It"
                iconElementRight={<IconButton><AddCircle /></IconButton>}
                onLeftIconButtonTouchTap={@props.toggleLeft}
            />
            <br />  
            <div className="container">
                <div className="row" style={'height':'40%'}>
                    <div className='col-sm-6'>
                        Roulette goes here
                    </div>
                    <div className='col-sm-6'>
                        <br></br>
                        <RaisedButton label="Spin!" onClick={@spinRoulette}/>
                    </div>
                </div>
                <div className="row" style={'height':'40%', 'overflow':'auto'}>
                    <List subheader="Previous Spinners">
                        <ListDivider />
                        {for spinner in @props.model.get_roulettes()
                            <ListItem primaryText={spinner.name} onClick={@props.model.set_curr_roulette.bind(this, spinner.name)}/>
                        }
                    </List>
                </div>
            </div>
        </div>

module.exports = React.createFactory(defaultPageView)
