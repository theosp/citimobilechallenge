Slides = new Mongo.Collection "slides"

@Slides = Slides

Router.route '/', ->
  if @ready()
    @render 'slides'
  else
    @render 'loading'

Router.route '/login', ->
  @render 'login'

Router.route '/reset', ->
  self = @
  Meteor.call 'reset', ->
    self.redirect('/')

Router.before ->
  if window.location.pathname == "/"
    setTimeout ->
      Reveal.initialize()
    , 1000

    @next()
  else
    @next()

Router.after ->
  if window.location.pathname.indexOf("admin") > -1
    $("body").css({overflow: "auto"})

if Meteor.isClient
  Meteor.subscribe 'slides'

  Template.slides.helpers
    slides: ->
      Slides.find({}, {sort: {order: 1}}).fetch()

if Meteor.isServer
  reset_slides = ->
    Slides.remove {}

    i = 0
    for slide in @slides_contents
      Slides.insert
        order: i++
        content: slide

  Meteor.startup ->
    # init
    #if Slides.find({}).count() == 0
    #  reset_slides()
    reset_slides()

  Meteor.methods
    reset: -> reset_slides()

  Meteor.publish 'slides', -> Slides.find({})
