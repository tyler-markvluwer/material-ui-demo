React = require('react')
DefaultPageView = require('./defaultPageView')
SpinnerTileView = require('./spinnerTileView')
Globals = require('./globals')

Mui = require('material-ui')
{AppBar, MenuItem, FlatButton, RaisedButton, LeftNav, Snackbar} = require('material-ui')

List = require('material-ui/lib/lists/list')
ListItem = require('material-ui/lib/lists/list-item')
Colors = require('material-ui/lib/styles/colors')
NavigationClose = require('material-ui/lib/svg-icons/navigation/close')
MoreVertIcon = require('material-ui/lib/svg-icons/navigation/more-vert')

menuItems = [
    { route: 'get-started', text: 'Get Started'},
    { route: 'customization', text: 'Customization' },
    { route: 'components', text: 'Components' },
    { type: MenuItem.Types.SUBHEADER, text: 'Resources' },
    {
       type: MenuItem.Types.LINK,
       payload: 'https://github.com/callemall/material-ui',
       text: 'GitHub'
    },
    {
       text: 'Disabled',
       disabled: true
    },
    {
       type: MenuItem.Types.LINK,
       payload: 'https://www.google.com',
       text: 'Disabled Link',
       disabled: true
    },
]

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
            when 0 then @props.model.set_cur_view("SPINNER_MAIN") # TODO fix hardcode
            when 1 then @props.model.set_cur_view("SPINNER_SELECT") # TODO fix hardcode
            when 2 then console.log "Components"
            else alert("error, unknown index in leftNav")

        console.log index
        console.log menuItem
        console.log "doing stuff"

    render: ->
        <div className='app-div' id='awesome-441-app-div'>
             <AppBar
                title="Shuffle-It"
                iconElementRight={<FlatButton label="Save" />} 
                onLeftIconButtonTouchTap={@toggleLeft}/>
            <br />  

            {switch @props.model.get_curr_view()
                when "SPINNER_MAIN" then <DefaultPageView model={@props.model} snack_show={@showSnack} />
                when "SPINNER_SELECT" then <SpinnerTileView model={@props.model} />
                else alert("error, unknown current view")
            }
            <LeftNav ref="leftNav" docked={false} menuItems={menuItems} onChange={@menuOnChange} />
            <Snackbar
                ref='snack'
                message="You Chose Something!"
                action="undo"
                openOnMount=true
                autoHideDuration={4000}
                onActionTouchTap={@toggleLeft}/>
        </div>
        # <div className='app-div' id='awesome-441-app-div'>
        #     <AppBar title="Title" />
        # </div>
            
            # CounterView
            #     model: @props.model
            #     innerHTML: 'div#1'

            # CounterView
            #     model: @props.model
            #     innerHTML: 'div#2'

            # CounterView
            #     model: @props.model
            #     innerHTML: 'div#3'
                
            # div
            #     className: 'centered-display'
            #     id: 'clicker-counter-display'
            #     'clicks: ' + @props.model.get_click_count()

module.exports = React.createFactory(appView)
