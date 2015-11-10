React = require('react')
{IconButton} = require('material-ui')
AddCircle = require('material-ui/lib/svg-icons/content/add')

plusButton = React.createClass
	render: ->
        <IconButton onClick={@props.click}><AddCircle /></IconButton>

module.exports = React.createFactory(plusButton)