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
          
          @listenTo @model,
            "change:assembly_url": @assemblyChange
            "change:width change:height": @dimensionsChange
            "change:camera_near change:camera_near": @cameraChange
            "change:selected": @selectedChange
            
          @viewModel = new Backbone.Model
            cad: null
            frame: null
            
            
          @listenTo @viewModel,
            "change:cad": @cadChange
          
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
              return view.viewModel.set "cad", cad if cad = @contentWindow.cad
              _.delay @cadLoaded, 1000
            @cadLoaded()
        
        assemblyChange: =>
          if cad = @viewModel.get "cad"
            if assemblyUrl = @model.get "assembly_url" 
              if not assemblyUrl.match /https?:\/\//
                assemblyUrl = $("<a/>", href: ".")[0].href + assemblyUrl
              cad.load assemblyUrl
          @
        
        cadChange: =>
          @assemblyChange() if @model.get "assembly_url"
          @
          
        dimensionsChange: =>
          @$el.css
            width: @model.get("width") or "100%"
            height: @model.get("height")
          @
        
        cameraChange: =>
          cad = @viewModel.get "cad"
          viewer = cad._viewer
          cam = viewer.camera

          cam.near = @model.get("camera_near") or cam.near
          cam.far = @model.get("camera_far") or cam.far
          cam.updateProjectionMatrix()
          viewer.invalidate()
          @
          
        selectedChange: =>
          cad = @viewModel.get "cad"
          sel = @model.get "selected"
          cad.tree.select_node cad.tree.get_node sel
          @

      manager.WidgetManager.register_widget_view "CADView", CADView
    
      # return to require.js someday!
      api = CADView: CADView)
  .call @, @define