React = require('react')
PlusButton = require('./plusButton')

{AppBar, FlatButton, TextField, Dialog, RaisedButton, ActionGrade, ListDivider, List, ListItem, Paper, IconButton, Snackbar} = require('material-ui')
AddCircle = require('material-ui/lib/svg-icons/content/add')
StarIcon = require('material-ui/lib/svg-icons/action/grade')
Colors = require('material-ui/lib/styles/colors')

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
            curr_text: ''
        }

    transitionCircleColor: (color, textColor, callback) ->
        console.log "transitioning color"
        $("#answer-circle").css("background-image", "")
        $("#answer-circle").animate(
            {
                'background-color': color,
                color: textColor,
            },
            {
                duration: FADE_OUT_TIME + FADE_IN_TIME - 300
                easing: 'easeOutCirc' # consider linear
            }
            
            if typeof(callback) == "function"
                callback()
        )

    setRandomTile: () ->
        max = @props.model.get_curr_roulette().get_active_tiles().length - 1
        min = 0
        index = Math.floor(Math.random() * (max - min + 1)) + min;

        @state.current_tile = @props.model.get_curr_roulette().get_active_tiles()[index]
        @props.model.recent_decision.tile = @state.current_tile.text
        @props.model.recent_decision.spinner = @props.model.get_curr_roulette().name

        @update()
        return @state.current_tile.text

    spinRoulette: ->
        $('div.roulette').roulette('start')

    showSnack: ->
        @props.snack_show()

    addSpinner: () ->
        @props.model.set_cur_view("SPINNER_NEW")

    animateClick: ->
        @transitionCircleColor(Colors.cyan500, "white")
        $('#answer-box').fadeOut(FADE_OUT_TIME, () =>
            @setRandomTile()
            $('#answer-box').text("Deciding...").fadeIn(FADE_IN_TIME).fadeOut(FADE_OUT_TIME, () =>
                @transitionCircleColor(Colors.yellow400, Colors.cyan500, () =>
                    $('#answer-box').text(@state.current_tile.text).fadeIn(FADE_IN_TIME, () =>
                        @refs.selectionDialog.show()
                    )
                )
            )
        )

    spinnerSelect: (spinner) ->
        $('#answer-box').text('')
        $("#answer-circle").css("background-color", "white")
        @state.curr_text = ''
        @props.model.set_curr_roulette(spinner)
        # @update()

    _onDialogSubmit: ->
        @refs.selectionDialog.dismiss()

    _getName: ->
        FB.api('/me', (response) ->
          return response.name
        )

    _shareResult: ->
        FB.ui({
          method: 'share_open_graph',
          action_type: 'og.likes',
          action_properties: JSON.stringify({
            object: {
              'og:url': "http://www-personal.umich.edu/~tylermar",
              'og:title': "I chose " + @props.model.recent_decision.tile + " from " + @props.model.recent_decision.spinner,
              'og:description': "Make your next decision!",
              'og:image': 'http://www-personal.umich.edu/~tylermar/permanent/screenshot.png'
            }
          })
        }, (response) ->
          console.log(response)
        )

    render: ->
        img_style = {'max-width':'100%', 'max-height':'100%'}
        outer_circle_style = {'height': '200px', 'width':'200px', backgroundImage: 'url(' + @props.model.get_curr_roulette().cover_photo_url() + ')', backgroundSize: 'cover'}
        # outer_circle_style = {'height': '200px', 'width':'200px'}
        inner_circle_style = {'height': '70px', 'width':'70px'}
        standardActions = [
          { text: 'Share', onTouchTap: @_shareResult, ref: 'share' },
          { text: 'Try Again', onTouchTap: @_onDialogSubmit, ref: 'submit' }
        ]
        customActions = [
            <div>
                <TextField hintText="username" />
                <br />
                <TextField hintText="password" />
                <br />
                <br />
                <RaisedButton label="Login" primary={true} style={{width:'40%'}} />
            </div>
        ]

        <div>
            <AppBar
                title="Shuffle-It"
                iconElementRight={<PlusButton click={@addSpinner} />}
                onLeftIconButtonTouchTap={@props.toggleLeft}
                onRightIconButtonTouchTap={@addNewSpinner}
            />

            <Dialog
                actions={customActions}
                actionFocus="submit"
                modal={true}
                openImmediately={false}>
            </Dialog>

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
                            <Paper id='answer-circle' zDepth={1} circle={true} style={outer_circle_style} onClick={@animateClick}>
                                <div className='row row-sm-flex-center'>
                                    <div id='answer-box' className='center-block' style={{'height': '201px', lineHeight: '201px', fontSize: '24px'}}>{@state.curr_text}</div>
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
                            @state.current_index += 1
                            if spinner.name == @props.model.get_curr_roulette().name
                                <ListItem primaryText={spinner.name} key={@state.current_index} onClick={@spinnerSelect.bind(this, spinner.name)} leftIcon={<IconButton><StarIcon /></IconButton>} />
                            else
                                <ListItem primaryText={spinner.name} key={@state.current_index} onClick={@spinnerSelect.bind(this, spinner.name)}/>
                        }
                    </List>
                </div>
            </div>
        </div>

module.exports = React.createFactory(defaultPageView)
