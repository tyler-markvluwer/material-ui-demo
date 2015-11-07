React = require('react')

# tag factories
div = React.createFactory('div')

counterView = React.createClass
    #################################
    #       User Functions
    #################################
    handleButtonClick: () ->
        @props.model.increment_click_count() # don't forget parentheses (function call operator). Hard bug to find
    
    #################################
    #       React Functions
    #################################
    componentDidMount: ->
        @props.model.on 'change', @update

    update: ->
        @forceUpdate()

    render: ->
        div
            className: 'counter-container'
            onClick: @handleButtonClick
            @props.innerHTML

module.exports = React.createFactory(counterView)
