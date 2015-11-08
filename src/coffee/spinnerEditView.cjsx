React = require('react')
{AppBar, Checkbox, IconMenu, IconButton, FlatButton, RaisedButton, ListDivider, List, ListItem, Snackbar} = require('material-ui')

MoreVertIcon = require('material-ui/lib/svg-icons/navigation/more-vert')
AddCircle = require('material-ui/lib/svg-icons/content/add')
MenuItem = require('material-ui/lib/menus/menu-item');

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

    render: ->
        <div>
            <AppBar
                title={"Edit: " + @props.model.get_curr_roulette().name}
                iconElementRight={<FlatButton label="save" />}
                onLeftIconButtonTouchTap={@props.toggleLeft}
            />
            <br />  
            <div className='container' id='spinner-tile-div'>
                <List subheader="Active Tiles">
                    <ListDivider />
                    {for tile in @props.model.get_curr_roulette().get_tiles()
                        if tile.active
                            <ListItem
                                primaryText={tile.text}
                                onClick={@props.model.set_curr_roulette.bind(this, tile.text)}
                                leftCheckbox={
                                    <Checkbox
                                        onCheck={tile.toggleActive}
                                    />
                                }
                                rightIconButton={
                                    <IconMenu
                                        iconButtonElement={<IconButton><MoreVertIcon /></IconButton>}
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
                                onClick={@props.model.set_curr_roulette.bind(this, tile.text)}
                                leftCheckbox={
                                    <Checkbox
                                        onCheck={tile.toggleActive}
                                    />
                                }
                            />
                    }
                </List>
            </div>
        </div>

module.exports = React.createFactory(spinnerEditView)