((require) ->
  require.config
    paths:
      jquery: "libs/jquery.min"
      jqueryui: "libs/jquery-ui.min"
      jstree: "libs/jstree.min"
      underscore: "libs/underscore-min"
      THREE: "libs/three.min"
      TrackballControls: "libs/TrackballControls"
      dat: "libs/dat.gui.min"
      bigScreen: "libs/bigscreen.min"
      VIS: "libs/visualize"
      Velvety: "shaders/VelvetyShader"
      NProgressRing: "libs/n-progress-ring"

    shim:
      jquery:
        exports: "$"

      jqueryui:
        deps: ["jquery"]

      jstree:
        deps: [
          "jquery"
          "jqueryui"
        ]

      underscore:
        exports: "_"

      THREE:
        exports: "THREE"

      TrackballControls:
        deps: ["THREE"]

      dat:
        exports: "dat"

      VIS:
        exports: "VIS"
        deps: [
          "jquery"
          "jqueryui"
          "bigScreen"
        ]

      viewer:
        deps: [
          "libs/threejs/EffectComposer"
          "libs/threejs/CopyShader"
          "libs/threejs/FXAAShader"
          "libs/threejs/SSAOShader"
          "libs/threejs/RenderPass"
          "libs/threejs/ShaderPass"
          "libs/threejs/MaskPass"
        ]

      "libs/threejs/EffectComposer":
        deps: ["THREE"]

      "libs/threejs/CopyShader":
        deps: ["THREE"]

      "libs/threejs/FXAAShader":
        deps: ["THREE"]

      "libs/threejs/SSAOShader":
        deps: ["THREE"]

      "libs/threejs/RenderPass":
        deps: ["THREE"]

      "libs/threejs/ShaderPass":
        deps: [
          "THREE"
          "libs/threejs/RenderPass"
        ]

      "libs/threejs/MaskPass":
        deps: ["THREE"]


  #
  #  Primary application entry point
  # 
  require [
      "./CAD"
      "jquery"
      "underscore"
      "THREE"
      "VIS"
    ],
    (CAD, $, THREE, VIS) ->
      cad = new CAD {
        viewContainerId: "cadjs-view"
        compassContainerId: "cadjs-compass"
        downloadsContainerId: "cadjs-downloads"
        treeContainerSelector: ".cadjs-tree"
      }

      cad.setupPage()
      
      window.cad = cad      
).call @, @require
