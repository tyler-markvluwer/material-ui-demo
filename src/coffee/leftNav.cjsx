React = require('react')
Mui = require('material-ui')
{IconButton, IconMenu, AppBar, MenuItem, LeftNav} = require('material-ui')

NavigationClose = require('material-ui/lib/svg-icons/navigation/close')
MoreVertIcon = require('material-ui/lib/svg-icons/navigation/more-vert')

menuItems = [
    { route: 'get-started', text: 'Get Started' },
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

leftNav = React.createClass
  render: ->
    this.refs.leftNav.toggle();

    <LeftNav ref="leftNav" docked={false} menuItems={menuItems} />
    
module.exports = React.createFactory(leftNav)
