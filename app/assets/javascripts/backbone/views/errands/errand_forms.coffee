class Sneakernet.Views.ErrandForms extends Backbone.View

  events:
    'click .next_form':'next_form'
    'click .submit_form':'submit_form'

  get: ->

  initialize: ->
    @current_form = 1
    @render()
    @switch_form()
    @errand = JSON.parse($.cookie("errand"))
    if not @errand
      Sneakernet.router.navigate("", {trigger:true})



  next_form: ->
    @current_form = @current_form + 1
    @switch_form()

  submit_form: ->
    alert "Yeey"

  render: ->
    @$el.html HandlebarsTemplates['errands/forms']({errand:@errand})
    @

  switch_form: ->
    $(".forms").hide()
    $(".forms[data-index='#{@current_form}']").show()