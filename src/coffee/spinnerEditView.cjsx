React = require('react')
{AppBar, Dialog, Checkbox, TextField, IconButton, FlatButton, RaisedButton, ListDivider, List, ListItem, Snackbar} = require('material-ui')

MoreVertIcon = require('material-ui/lib/svg-icons/navigation/more-vert')
AddCircle = require('material-ui/lib/svg-icons/content/add')
IconMenu = require('material-ui/lib/menus/icon-menu');
MenuItem = require('material-ui/lib/menus/menu-item');
Colors = require('material-ui/lib/styles/colors')

iconButtonElement = (
  <IconButton
    touch={true}
    tooltip="more"
    tooltipPosition="bottom-right">
    <MoreVertIcon color={Colors.grey400} />
  </IconButton>
)

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
            currRef: null
        }

    storeInput: () ->
        @state.tileInput = @refs.tileInput.getValue()
        @update()

    addTile: () ->
        if @state.tileInput.length
            @props.model.get_curr_roulette().add_tile(@state.tileInput, null)
            
            @state.tileInput = ''
            @refs.tileInput.clearValue()
            @update()

    goToMain: () ->
        @props.model.set_cur_view("SPINNER_MAIN")

    _deleteSpinner: () ->
        curr_name = @props.model.get_curr_roulette().name
        @props.model.remove_roulette(curr_name)
        @props.model.reset_curr_roulette()

        @goToMain()

    updateCallback: () ->
        @props.model.get_curr_roulette().update_tile(@state.currRef)

    editActiveTileCallback: () ->
        @deleteCallback()
        @refs.tileInput.setValue(@state.currRef)
        @state.tileInput = @state.currRef
        @refs.tileInput.focus()

    editInactiveTileCallback: () ->
        @deleteCallback()
        @refs.tileInput.setValue(@state.currRef)
        @refs.tileInput.focus()
        

    deleteCallback: () ->
        @props.model.get_curr_roulette().remove_tile(@state.currRef)
        @update()

    setCurrListItem: (ref) ->
        @state.currRef = ref

    showDeleteDialog: () ->
        @refs.deleteDialog.show()

    _save: () ->
        @props.model.set_cur_view("SPINNER_SELECT")

    render: ->
        rightIconMenuForActive = (
            <IconMenu iconButtonElement={iconButtonElement} >
                <MenuItem onClick={@updateCallback}>Disable</MenuItem>
                <MenuItem onClick={@editActiveTileCallback}>Edit</MenuItem>
                <MenuItem onClick={@deleteCallback}>Delete</MenuItem>
            </IconMenu>
        )
        rightIconMenuForInactive = (
            <IconMenu iconButtonElement={iconButtonElement} >
                <MenuItem onClick={@updateCallback}>Enable</MenuItem>
                <MenuItem onClick={@editInactiveTileCallback}>Edit</MenuItem>
                <MenuItem onClick={@deleteCallback}>Delete</MenuItem>
            </IconMenu>
        )
        standardActions = [
          { text: 'Cancel', ref: 'cancelRef'},
          { text: 'Delete', onTouchTap: @_deleteSpinner, ref: 'deleteRef' }
        ]

        <div>
            <AppBar
                title={ @props.model.get_curr_roulette().name}
                iconElementRight={<FlatButton label="save" onClick={@_save} />}
                onLeftIconButtonTouchTap={@props.toggleLeft}
            />
            <Dialog
                ref='deleteDialog'
                title={"Delete " + @props.model.get_curr_roulette().name + "?"}
                actions={standardActions}
                actionFocus="cancelRef"
            >
                {"Are you sure you want to delete " + @props.model.get_curr_roulette().name + "? This action cannot be reversed!"}
            </Dialog>

            <br />  
            <div className='container' id='spinner-tile-div' style={height: '70%', overflowY: 'auto'}>
                <div className='row'>
                    <div className='col-sm-3'></div>
                    <div className='col-sm-6'>
                        <TextField
                            ref='tileInput'
                            hintText="e.g. Pizza"
                            floatingLabelText="Add New Tile"
                            onChange={@storeInput}
                            onEnterKeyDown={@addTile}
                            style={width: '100%'}
                        />
                        <RaisedButton
                            label="Add"
                            onClick={@addTile}
                            primary={true}
                            style={width: '100%'}
                        />
                    </div>
                    <div className='col-sm-3'></div>
                </div>

                <List subheader="Active Tiles">
                    <ListDivider />
                    {if @state.tileInput.length #if the length of the new tile is > 0 add it to ListItem
                        <ListItem
                            style={{color:Colors.amber900}}
                            primaryText={@state.tileInput}
                            disabled=true
                        />
                    }
                    {for tile in @props.model.get_curr_roulette().get_tiles()
                        if tile.active
                            <ListItem
                                ref={tile.text}
                                rightIconButton={rightIconMenuForActive}
                                primaryText={tile.text}
                                onTouchTap={tile.toggleActive}
                                onClick={@setCurrListItem.bind(this, tile.text)}
                            />
                    }
                </List>
                <List subheader="Inactive Tiles">
                    <ListDivider />
                    {for tile in @props.model.get_curr_roulette().get_tiles()
                        if not tile.active
                            <ListItem
                                ref={tile.text}
                                rightIconButton={rightIconMenuForInactive}
                                primaryText={tile.text}
                                onTouchTap={tile.toggleActive}
                                onClick={@setCurrListItem.bind(this, tile.text)}
                            />
                    }
                </List>
            </div>
            <div className='footer navbar-fixed-bottom' style={zIndex: 0}>
                <div className='container'>
                    <RaisedButton
                        label="Select New Image"
                        onClick={''}
                        default={true}
                        style={width: '100%'}
                    />
                    <RaisedButton
                        label="Delete Spinner"
                        onClick={@showDeleteDialog}
                        default={true}
                        style={width: '100%', margin: '2%'}
                    />
                </div>
            </div>
        </div>

module.exports = React.createFactory(spinnerEditView)
