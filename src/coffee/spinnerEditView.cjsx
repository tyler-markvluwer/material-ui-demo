React = require('react')
{AppBar, Checkbox, IconMenu, TextField, IconButton, FlatButton, RaisedButton, ListDivider, List, ListItem, Snackbar} = require('material-ui')

MoreVertIcon = require('material-ui/lib/svg-icons/navigation/more-vert')
AddCircle = require('material-ui/lib/svg-icons/content/add')
MenuItem = require('material-ui/lib/menus/menu-item');
Colors = require('material-ui/lib/styles/colors')

menuItems = [
    {primaryText: 'item 1', index: 1},
    {primaryText: 'item 2', index: 2},
]

spinnerEditView = React.createClass    
    #################################
    #       React Functions
    #################################
    componentDidMount: ->
        @props.model.on 'change', @update

    update: ->
        @forceUpdate()

    getInitialState: ->
        {
            tileInput: ''
        }

    storeInput: () ->
        @state.tileInput = @refs.tileInput.getValue()
        @update()
        console.log @state

    addTile: () ->
        if @state.tileInput.length
            @props.model.get_curr_roulette().add_tile(@state.tileInput, null)
            console.log @props.model.get_curr_roulette()
            @state.tileInput = ''
            @refs.tileInput.clearValue()
            @update()

    goToMain: () ->
        @props.model.set_cur_view("SPINNER_MAIN")

    render: ->
        <div>
            <AppBar
                title={"Edit: " + @props.model.get_curr_roulette().name}
                iconElementRight={<FlatButton label="save" onClick={@goToMain} />}
                onLeftIconButtonTouchTap={@props.toggleLeft}
                onRightIconButtonTouchTap={@testFunc}
            />
            <br />  
            <div className='container' id='spinner-tile-div'>
                <div className='row'>
                    <div className='col-sm-3'>
                        <TextField
                            ref='tileInput'
                            hintText="e.g. Pizza"
                            floatingLabelText="Add New Tile"
                            onChange={@storeInput}
                            onEnterKeyDown={@addTile}
                        />
                    </div>
                    <div className='col-sm-3'>
                        <RaisedButton
                            label="Add"
                            onClick={@addTile}
                            primary={true} />
                    </div>
                </div>
                <List subheader="Active Tiles">
                    <ListDivider />
                    {if @state.tileInput.length
                        <ListItem
                            style={{color:Colors.amber900}}
                            primaryText={@state.tileInput}
                            disabled=true
                        />
                    }
                    {for tile in @props.model.get_curr_roulette().get_tiles()
                        if tile.active
                            <ListItem
                                primaryText={tile.text}
                                onClick={tile.toggleActive}
                                rightIconButton={
                                    <IconMenu iconButtonElement={
                                        <IconButton><MoreVertIcon /></IconButton>}
                                    />
                                }
                            />
                    }
                </List>
                <List subheader="Inactive Tiles">
                    <ListDivider />
                    {for tile in @props.model.get_curr_roulette().get_tiles()
                        if not tile.active
                            <ListItem
                                primaryText={tile.text}
                                onClick={tile.toggleActive}
                            />
                    }
                </List>
            </div>
        </div>

module.exports = React.createFactory(spinnerEditView)