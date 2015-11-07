React = require('react')
CounterView = require('./counterView')
Mui = require('material-ui')

AppBar = Mui.AppBar
IconMenu = Mui.IconMenu
IconButton = Mui.IconButton
MenuItem = Mui.MenuItem
MoreVertIcon = Mui.MoreVertIcon

appView = React.createClass    
    #################################
    #       React Functions
    #################################
    componentDidMount: ->
        @props.model.on 'change', @update

    update: ->
        @forceUpdate()

    render: ->
        # <div className='app-div' id='awesome-441-app-div'><AppBar title="Title" iconElementRight={<IconMenu iconButtonElement={<IconButton><MoreVertIcon /></IconButton>}><MenuItem primaryText="Refresh" index={0} /><MenuItem primaryText="Help" index={1} /><MenuItem primaryText="Sign out" index={2} /></IconMenu>}/></div>
        <div className='app-div' id='awesome-441-app-div'>
            <AppBar title="Title" />
        </div>
            
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
