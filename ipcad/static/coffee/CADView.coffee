###
The browser-side counterpart to CAD

@author Nicholas Bollweg
@copyright Nicholas Bollweg 2014
@version 0.1.0
@license BSD
###

((define) ->
  define [
      "widgets/js/manager"
      "widgets/js/widget"
      "jquery"
      "underscore"
      "backbone"
    ],
    (manager, widget, $, _, Backbone) ->
      class CADView  extends widget.DOMWidgetView
        className: "ipcad CADView"
      
        render: =>
          _.defer @update
          
          @viewModel = new Backbone.Model
            cad: null
            frame: null
            
          @viewModel.on
            "change:cad": @hasCAD
          
          @$frame = $ "<iframe/>",
            src: "/nbextensions/ipcad/CADViewFrame.html"
        
          @$frame
            .load @frameLoaded()
            .appendTo @$el

          @

        frameLoaded: =>
          view = @
          (frame) ->
            view.viewModel.set "frame", @
            @cadLoaded = => 
              view.viewModel.set "cad", cad if cad = @contentWindow.cad
              _.delay @cadLoaded, 1000
            @cadLoaded()
        
        hasCAD: =>
          console.log @viewModel.get "cad"

        update: (options) =>
          super options
    
      manager.WidgetManager.register_widget_view "CADView", CADView
    
      # return to require.js someday!
      api = CADView: CADView)
  .call @, @define