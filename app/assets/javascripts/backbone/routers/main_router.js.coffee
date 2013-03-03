class Sneakernet.Routers.MainsRouter extends Backbone.Router
  initialize: (options) ->
    @header = new Sneakernet.Views.HeaderView({el:"#header"})
    $("html").on "click", ".link", (event) ->
      event.preventDefault()
      if @getAttribute('data-page') == 'home'
        Sneakernet.router.navigate @getAttribute(''), {trigger:true}
      else
        Sneakernet.router.navigate @getAttribute('href'), {trigger:true}

  routes:
    '': 'main'
    'about':'about'
    'errands':'errands'
    '_=_':'main'

  main: ->
    @view = new Sneakernet.Views.HomeView({el:"#content"})

  errands: ->
    @errands = new Sneakernet.Collections.Errands()
    @errands.fetch()
    @view = new Sneakernet.Views.ErrandsView
      el:"#content"
      collection: @errands

  about: ->
    @view = new Sneakernet.Views.StaticView({el:"#content", page:'about'})
