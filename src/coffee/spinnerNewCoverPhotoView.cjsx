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

spinnerNewCoverPhotoView = React.createClass    
    #################################
    #       React Functions
    #################################
    componentDidMount: ->
        @props.model.on 'change', @update
        @refs.imageTerms.focus()

    update: ->
        @forceUpdate()

    getInitialState: ->
        {
            img_terms: ''
            spinnerName: "New Spinner"
            imgs: []
            saved_img: ''
            most_recent_action: new Date()
        }

    getPhotoUrl: (photo) ->
        return "https://farm" + photo.farm + ".staticflickr.com/" + photo.server + "/" + photo.id + "_" + photo.secret + "_c.jpg";

    getTags: () ->
        tags = @state.img_terms.split(' ')
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

    secDiff: (time1, time2) ->
        return (time1.getTime() - time2.getTime()) / 1000

    _storeValue: () ->
        now = new Date()

        # if sec_diff > 2
        @state.img_terms = @refs.imageTerms.getValue()
        setTimeout(
            () =>
                if @secDiff(new Date(), @state.most_recent_action) > 1
                    if @state.img_terms.length
                        @getImages()
                @state.most_recent_action = new Date()
            , 1500)
        

    selectImage: (imgUrl) ->
        @state.saved_img = imgUrl
        @update()

    save: () ->
        @props.model.get_curr_roulette().img = @state.saved_img
        @props.model.set_cur_view("SPINNER_EDIT")

    cancelNew: ->
        @props.model.set_cur_view("SPINNER_SELECT")

    render: ->
        <div>
            <AppBar
                title="Select Cover Image"
                iconElementRight={<FlatButton label="save" onClick={@save} />}
                onLeftIconButtonTouchTap={@props.toggleLeft}
            />
            <br />
            <div className='container'>
                <TextField ref='imageTerms' floatingLabelText="Search for cover image" onChange={@_storeValue} />
            </div>

            <GridList
                cellHeight={200}
                style={{width: '100%', overflowY: 'auto'}}
            >
            {for img in @state.imgs
                if img != @state.saved_img
                    <GridTile
                        title = " "
                        actionIcon={<IconButton><StarBorder color="white"/></IconButton>}
                        onClick={@selectImage.bind(this, img)}
                    >
                    <img src={img} /></GridTile>
                else
                    <GridTile
                        title = " "
                        actionIcon={<IconButton><Star color="red"/></IconButton>}
                        onClick={@selectImage.bind(this, img)}
                    >
                    <img src={img} /></GridTile>
            }
            </GridList>
        </div>

module.exports = React.createFactory(spinnerNewCoverPhotoView)
