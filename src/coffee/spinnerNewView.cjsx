React = require('react')
Roulette = require('./roulette')

{AppBar, Checkbox, GridList, IconMenu, Dialog, GridTile, TextField, IconButton, FlatButton, RaisedButton, ListDivider, List, ListItem, Snackbar} = require('material-ui')

MoreVertIcon = require('material-ui/lib/svg-icons/navigation/more-vert')
AddCircle = require('material-ui/lib/svg-icons/content/add')
MenuItem = require('material-ui/lib/menus/menu-item')
Colors = require('material-ui/lib/styles/colors')
StarBorder = require('material-ui/lib/svg-icons/toggle/star-border')
Star = require('material-ui/lib/svg-icons/toggle/star')

API_KEY = "f8d1a0527ed82bd8587f5ec69886ba9c"
NUM_PHOTOS = "10"

spinnerNewView = React.createClass    
    #################################
    #       React Functions
    #################################
    componentDidMount: ->
        @props.model.on 'change', @update

    update: ->
        console.log "updating"
        @forceUpdate()

    getInitialState: ->
        {
            img_terms: ''
            spinnerName: "New Spinner"
            imgs: []
            saved_img: ''
            most_recent_action: new Date()
        }

    _onDialogSubmit: ->
        @state.spinnerName = @state.tempName
        @refs.nameDialog.dismiss()
        @update()
        @state.currRoul = new Roulette(@state.spinnerName)
        @props.model.add_roulette(@state.currRoul)
        @props.model.set_curr_roulette(@state.currRoul.name)

    _storeName: ->
        @state.tempName = @refs.spinnerName.getValue()

    getPhotoUrl: (photo) ->
        return "https://farm" + photo.farm + ".staticflickr.com/" + photo.server + "/" + photo.id + "_" + photo.secret + "_c.jpg";

    getTags: () ->
        tags = @state.img_terms.split(' ')
        console.log tags
        return tags.join()

    getApiUrl: () ->
        url = "https://api.flickr.com/services/rest/?method=flickr.photos.search\&api_key=" + API_KEY + "\&tags=" + @getTags() + "\&per_page=" + NUM_PHOTOS + "\&sort=interestingness-desc" + "\&format=json\&nojsoncallback=1"
        return url

    getImages: () ->
        @state.imgs = []
        $.ajax(
            url: @getApiUrl()
        ).then((data) =>
            $.each(data.photos.photo, (i, photo) =>
                src = @getPhotoUrl(photo)

                if @state.imgs.length > NUM_PHOTOS
                    @state.imgs.shift()

                @state.imgs.push src
            )
        ).then(() =>
            @update()
        )

    _storeValue: () ->
        now = new Date()
        sec_diff = (now.getTime() - @state.most_recent_action.getTime()) / 1000

        # if sec_diff > 2
        @state.imgs = []
        @state.img_terms = @refs.imageTerms.getValue()
        if @state.img_terms.length
            @getImages()
            console.log @state.img_terms

    selectImage: (imgUrl) ->
        @state.saved_img = imgUrl
        console.log "saving: " + @state.saved_img
        @update()

    save: () ->
        console.log "saving"
        @state.currRoul.img = @state.saved_img
        @props.model.set_cur_view("SPINNER_EDIT")

    cancelNew: ->
        @props.model.set_cur_view("SPINNER_MAIN")
        @refs.nameDialog.dismiss()

    render: ->
        standardActions = [
          { text: 'Cancel', onTouchTap: @cancelNew},
          { text: 'Submit', onTouchTap: @_onDialogSubmit, ref: 'submit' }
        ]

        <div>
            <AppBar
                title={@state.spinnerName}
                iconElementRight={<FlatButton label="save" onClick={@save} />}
                onLeftIconButtonTouchTap={@props.toggleLeft}
            />
            <br />
            <div className='container'>
                <TextField ref='imageTerms' hintText="Search for cover image" onChange={@_storeValue} />
            </div>
            
            <Dialog
                ref='nameDialog'
                title="Create New Spinner"
                actions={standardActions}
                actionFocus="submit"
                modal=true
                openImmediately=true
            >
                <TextField hintText="Spinner Name" ref='spinnerName' onChange={@_storeName} />
                Choose a unique name for your new spinner!
            </Dialog>

            <GridList
                cellHeight={200}
                style={{width: '100%', height: '80%', overflowY: 'auto'}}
            >
            {for img in @state.imgs
                if img != @state.saved_img
                    <GridTile
                        title="test"
                        subtitle={<span>by <b>author_here</b></span>}
                        actionIcon={<IconButton><StarBorder color="white"/></IconButton>}
                        onClick={@selectImage.bind(this, img)}
                    >
                    <img src={img} /></GridTile>
                else
                    <GridTile
                        title="test"
                        subtitle={<span>by <b>author_here</b></span>}
                        actionIcon={<IconButton><Star color="red"/></IconButton>}
                        onClick={@selectImage.bind(this, img)}
                    >
                    <img src={img} /></GridTile>
            }
            </GridList>
        </div>

module.exports = React.createFactory(spinnerNewView)