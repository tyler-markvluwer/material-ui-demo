React = require('react')
CounterView = require('./counterView')
Mui = require('material-ui')
{GridList, GridTile, IconButton} = require('material-ui')
StarBorder = require('material-ui/lib/svg-icons/toggle/star-border')

List = require('material-ui/lib/lists/list')
ListItem = require('material-ui/lib/lists/list-item')
ListDivider = require('material-ui/lib/lists/list-divider')
Colors = require('material-ui/lib/styles/colors')
NavigationClose = require('material-ui/lib/svg-icons/navigation/close')
MoreVertIcon = require('material-ui/lib/svg-icons/navigation/more-vert')

tilesData = [
    {'title': 'a', 'author': 'tmark', 'img': 'http://material-ui.com/images/grid-list/00-52-29-429_640.jpg'},
    {'title': 'b', 'author': 'tmarkv', 'img': 'http://material-ui.com/images/grid-list/00-52-29-429_640.jpg'},
    {'title': 'c', 'author': 'tmarkvl', 'img': 'http://material-ui.com/images/grid-list/00-52-29-429_640.jpg'},
]

spinnerTileView = React.createClass    
    #################################
    #       React Functions
    #################################
    componentDidMount: ->
        @props.model.on 'change', @update

    update: ->
        @forceUpdate()

    render: ->
        <div className='container' id='spinner-tile-div'>
            <GridList
                cellHeight={200}
                style={{width: '100%', height: 410, overflowY: 'auto'}}
            >
            {for tile in tilesData
                <GridTile
                    title={tile.title}
                    subtitle={<span>by <b>{tile.author}</b></span>}
                    actionIcon={<IconButton><StarBorder color="white"/></IconButton>}
                >
                <img src={tile.img} /></GridTile>
            }
            </GridList>
        </div>

module.exports = React.createFactory(spinnerTileView)