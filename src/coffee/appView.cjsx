React = require('react')
DefaultPageView = require('./defaultPageView')
SpinnerTileView = require('./spinnerTileView')
SpinnerEditView = require('./spinnerEditView')
SpinnerNewView = require('./spinnerNewView')
Globals = require('./globals')
Resources = require('./resources')

Mui = require('material-ui')
{MenuItem, LeftNav, Snackbar} = require('material-ui')

List = require('material-ui/lib/lists/list')
ListItem = require('material-ui/lib/lists/list-item')
Colors = require('material-ui/lib/styles/colors')
NavigationClose = require('material-ui/lib/svg-icons/navigation/close')
MoreVertIcon = require('material-ui/lib/svg-icons/navigation/more-vert')

appView = React.createClass    
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
                console.log('slowDown');
            stopCallback: ($stopElm) =>
                console.log('stop');
                @showSnack()
        }

        $('div.roulette').roulette(@roulette_options);
        @props.model.on 'change', @update

    update: ->
        @forceUpdate()

    spinRoulette: ->
        $('div.roulette').roulette('start')

    toggleLeft: ->
        @refs.leftNav.toggle()

    showSnack: ->
        @refs.snack.show()

    menuOnChange: (event, index, menuItem) ->
        switch index
            when 0 then @props.model.set_cur_view("SPINNER_SELECT") # TODO fix hardcode
            when 1 then @props.model.set_cur_view("SPINNER_MAIN") # TODO fix hardcode
            when 2
                if @props.model.get_curr_roulette()
                    @props.model.set_cur_view("SPINNER_EDIT") # TODO fix hardcode
            when 3 then @props.model.set_cur_view("SPINNER_NEW") # TODO fix hardcode
            else alert("error, unknown index in leftNav")

    render: ->
        console.log "disable edit? "
        console.log(@props.model.get_curr_roulette()==null)
        console.log @props.model.get_curr_roulette()
        menuItems = [
            { route: 'customization', text: 'Home', disabled: @props.model.get_curr_roulette()==null},
            { route: 'get-started', text: 'ShuffleIt!', disabled: @props.model.get_curr_roulette()==null},
            { route: 'components', text: 'Edit Spinner', disabled: @props.model.get_curr_roulette()==null},
            { route: 'new-spinner', text: 'Add Spinner'},
            { type: MenuItem.Types.SUBHEADER, text: 'User Options' },
            # {
            #    type: MenuItem.Types.LINK,
            #    payload: 'https://github.com/callemall/material-ui',
            #    text: 'GitHub'
            # },
            {
               text: 'Login',
               disabled: true
            },
            # {
            #    type: MenuItem.Types.LINK,
            #    payload: 'https://www.google.com',
            #    text: 'Disabled Link',
            #    disabled: true
            # },
        ]

        <div className='app-div' id='awesome-441-app-div'>
            {switch @props.model.get_curr_view()
                when Resources.SPIN_VIEW
                    <DefaultPageView
                        model={@props.model}
                        snack_show={@showSnack}
                        toggleLeft={@toggleLeft}
                    />
                when Resources.SELECT_VIEW
                    <SpinnerTileView
                        model={@props.model}
                        toggleLeft={@toggleLeft}
                    />
                when Resources.EDIT_VIEW
                    <SpinnerEditView
                        model={@props.model}
                        toggleLeft={@toggleLeft}
                    />
                when Resources.NEW_VIEW
                    <SpinnerNewView
                        model={@props.model}
                        toggleLeft={@toggleLeft}
                    />
                else alert("error, unknown current view")
            }
            <LeftNav ref="leftNav" docked={false} menuItems={menuItems} onChange={@menuOnChange} />
            <Snackbar
                ref='snack'
                message="You Chose Something!"
                action="undo"
                openOnMount=false
                autoHideDuration={4000}
                onActionTouchTap={@toggleLeft}/>
        </div>

module.exports = React.createFactory(appView)
