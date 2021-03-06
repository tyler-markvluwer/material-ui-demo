React = require('react')
Resources = require('./resources')

{AppBar, Dialog, Checkbox, TextField, IconButton, FontIcon, FlatButton, RaisedButton, ListDivider, List, ListItem, Snackbar} = require('material-ui')

MoreVertIcon = require('material-ui/lib/svg-icons/navigation/more-vert')
AddCircle = require('material-ui/lib/svg-icons/content/add')

IconMenu = require('material-ui/lib/menus/icon-menu')
MenuItem = require('material-ui/lib/menus/menu-item')
Colors = require('material-ui/lib/styles/colors')
styles = require('material-ui/lib/styles')

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
            editState: true
        }

    storeInput: () ->
        @state.tileInput = @refs.tileInput.getValue()
        @update()

    addTile: () ->
        if @state.tileInput.length and not @props.model.get_curr_roulette().get_tile(@state.tileInput)
            @props.model.get_curr_roulette().add_tile(@state.tileInput, null, @state.editState)
            @state.tileInput = ''
            @refs.tileInput.clearValue()
            @update()

        @state.editState = true

    goToMain: () ->
        @props.model.set_cur_view(Resources.SELECT_VIEW)

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
        @state.editState = false
        @deleteCallback()
        @refs.tileInput.setValue(@state.currRef)
        @state.tileInput = @state.currRef
        @refs.tileInput.focus()

    deleteCallback: () ->
        @props.model.get_curr_roulette().remove_tile(@state.currRef)
        @update()

    setCurrListItem: (ref) ->
        @state.currRef = ref

    showDeleteDialog: () ->
        @refs.deleteDialog.show()

    # _save: () ->
    #     @props.model.set_cur_view(Resources.SELECT_VIEW)

    _gotoSelectImgView: () ->
        @props.model.set_cur_view(Resources.NEW_COVER_PHOTO_VIEW)

    _onActiveContextMenuItemTouchTap: (event, value) ->
        switch value
            when "Disable" then @updateCallback()
            when "Edit" then @editActiveTileCallback()
            when "Delete" then @deleteCallback()

    _onInactiveContextMenuItemTouchTap: (event, value) ->
        switch value
            when "Enable" then @updateCallback()
            when "Edit" then @editInactiveTileCallback()
            when "Delete" then @deleteCallback()

    render: ->
        rightIconMenuForActive = (
            <IconMenu iconButtonElement={iconButtonElement} onChange={@_onActiveContextMenuItemTouchTap}>
                <MenuItem value='Disable'>Disable</MenuItem>
                <MenuItem value='Edit'>Edit</MenuItem>
                <MenuItem value='Delete'>Delete</MenuItem>
            </IconMenu>
        )
        rightIconMenuForInactive = (
            <IconMenu iconButtonElement={iconButtonElement} onChange={@_onInactiveContextMenuItemTouchTap}>
                <MenuItem value='Enable'>Enable</MenuItem>
                <MenuItem value='Edit'>Edit</MenuItem>
                <MenuItem value='Delete'>Delete</MenuItem>
            </IconMenu>
        )
        standardActions = [
          { text: 'Cancel', ref: 'cancelRef'},
          { text: 'Delete', onTouchTap: @_deleteSpinner, ref: 'deleteRef' }
        ]

        <div>
            <AppBar
                title={ @props.model.get_curr_roulette().name}
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
            <div className='container' id='spinner-tile-div' style={height: '70%', overflowY: 'auto', overflowX: 'hidden'}>
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
                    <div className='row'>
                        <div className='col-sm-12 col-centered'>
                            <RaisedButton
                                secondary={true}
                                label="Select New Image"
                                onClick={@_gotoSelectImgView}
                                secondary={true}
                                style={minWidth: '25%'}
                            />
                        </div>
                    </div>
                    <div className='row'>
                        <div className='col-sm-12 col-centered'>
                            <RaisedButton
                                id='delete-spinner-button'
                                label="Delete Spinner"
                                onClick={@showDeleteDialog}
                                default={true}
                                backgroundColor={Colors.red500}
                                hoverColor={Colors.red100}
                                rippleColor={Colors.red100}
                                labelColor='white'
                                style={minWidth: '25%', marginTop: '1%', marginBottom: '2%'}
                            />
                        </div>
                    </div>
                </div>
            </div>
        </div>

module.exports = React.createFactory(spinnerEditView)
