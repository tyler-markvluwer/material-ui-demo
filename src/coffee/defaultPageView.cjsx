React = require('react')
PlusButton = require('./plusButton')

{AppBar, FlatButton, Dialog, RaisedButton, ActionGrade, ListDivider, List, ListItem, Paper, IconButton, Snackbar} = require('material-ui')
AddCircle = require('material-ui/lib/svg-icons/content/add')
StarIcon = require('material-ui/lib/svg-icons/action/grade')

FADE_OUT_TIME = 1000
FADE_IN_TIME = 3000

defaultPageView = React.createClass    
    #################################
    #       React Functions
    #################################
    componentDidMount: ->
        @props.model.on 'change', @update

    update: ->
        @forceUpdate()

    getInitialState: ->
        {
            current_index: 0
            current_tile: @props.model.get_curr_roulette().get_active_tiles()[0]
        }

    setRandomTile: () ->
        max = @props.model.get_curr_roulette().get_active_tiles().length - 1
        min = 0
        index = Math.floor(Math.random() * (max - min + 1)) + min;

        @state.current_tile = @props.model.get_curr_roulette().get_active_tiles()[index]
        @update()
        return @state.current_tile.text

    spinRoulette: ->
        $('div.roulette').roulette('start')

    showSnack: ->
        @props.snack_show()

    addSpinner: () ->
        @props.model.set_cur_view("SPINNER_NEW")

    animateClick: ->
        $('#answer-box').fadeOut(FADE_OUT_TIME, () =>
            @setRandomTile()
            $('#answer-box').text("Deciding...").fadeIn(FADE_IN_TIME).fadeOut(FADE_OUT_TIME, () =>
                $('#answer-box').text(@state.current_tile.text).fadeIn(FADE_IN_TIME, () =>
                    @refs.selectionDialog.show()
                )
            )
        )

    _onDialogSubmit: ->
        @refs.selectionDialog.dismiss()

    render: ->
        outer_circle_style = {'height': '200px', 'width':'200px'}
        inner_circle_style = {'height': '70px', 'width':'70px'}
        standardActions = [
          { text: 'Try Again' },
          { text: 'Submit', onTouchTap: @_onDialogSubmit, ref: 'submit' }
        ]

        <div>
            <AppBar
                title="Shuffle-It"
                iconElementRight={<PlusButton click={@addSpinner} />}
                onLeftIconButtonTouchTap={@props.toggleLeft}
                onRightIconButtonTouchTap={@addNewSpinner}
            />
            <Dialog
                ref='selectionDialog'
                title="You've Made a Decision!"
                actions={standardActions}
                actionFocus="submit"
                modal={true}>
                {"Congrats on choosing " + @state.current_tile.text + "! If you are unhappy with selection click 'Try Again'!"}
            </Dialog>

            <br />  
            <div className="container">
                <div className="row" style={'height':'40%'}>
                    <div className='col-sm-4'></div>
                    <div className='col-sm-4'>
                        <div className='center-block'>
                            <Paper zDepth={1} circle={true} style={outer_circle_style} onClick={@animateClick}>
                                <div className='row row-sm-flex-center'>
                                    <div id='answer-box' className='center-block' style={{'height': '201px', lineHeight: '201px', fontSize: '24px'}}>
                                        Click To Choose!
                                    </div>
                                </div>
                            </Paper>
                        </div>
                    </div>
                    <div className='col-sm-4'></div>
                </div>
                <div className="row" style={'height':'40%', 'overflow':'auto'}>
                    <List subheader="Previous Spinners">
                        <ListDivider />
                        {for spinner in @props.model.get_roulettes()
                            if spinner.name == @props.model.get_curr_roulette().name
                                <ListItem primaryText={spinner.name} onClick={@props.model.set_curr_roulette.bind(this, spinner.name)} leftIcon={<IconButton><StarIcon /></IconButton>} />
                            else
                                <ListItem primaryText={spinner.name} onClick={@props.model.set_curr_roulette.bind(this, spinner.name)}/>
                        }
                    </List>
                </div>
            </div>
        </div>

module.exports = React.createFactory(defaultPageView)
