class Sneakernet.Routers.MainsRouter extends Backbone.Router
  initialize: (options) ->
    @header = new Sneakernet.Views.HeaderView({el:"#header"})
    @footer = new Sneakernet.Views.FooterView({el:"#footer"})
    $("html").on "click", ".link", (event) ->
      event.preventDefault()
      if @getAttribute('data-page') == 'home'
        Sneakernet.router.navigate @getAttribute(''), {trigger:true}
      else
        Sneakernet.router.navigate @getAttribute('href'), {trigger:true}

  routes:
    '': 'main'
    'about':'about'
    'static/:page':'static'
    'users/:id':'profile'
    'errands/:id':'single_errand'
    'summary':'summary'
    'errands':'errands'
    'request':'request'
    'dashboard':'dashboard'
    '_=_':'main'

  main: ->
    @view = new Sneakernet.Views.HomeView({el:"#content"})
    select_city("#deliver_to", default_destination.display_name)
    select_city("#deliver_from", default_source.display_name)

  request: ->
    @view = new Sneakernet.Views.ErrandForms({el:"#content"})

  summary: ->
    @view = new Sneakernet.Views.ErrandSummary({el:"#content"})

  dashboard: ->
    @view = new Sneakernet.Views.Dashboard({el:"#content"})

  profile: (id) ->
    @view = new Sneakernet.Views.Profile
      el:"#content"
      user_id:id

  single_errand: (id) ->
    @view = new Sneakernet.Views.SingleErrand
      el:"#content"
      errand_id:id

  errands: ->
    @view = new Sneakernet.Views.ErrandsView
      el:"#content"

  about: ->
    @view = new Sneakernet.Views.StaticView({el:"#content", page:'about'})

  static: (page) ->
    @view = new Sneakernet.Views.StaticView({el:"#content", page:page})
