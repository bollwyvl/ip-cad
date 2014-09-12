// Generated by CoffeeScript 1.8.0

/*
The browser-side counterpart to CAD

@author Nicholas Bollweg
@copyright Nicholas Bollweg 2014
@version 0.1.0
@license BSD
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  (function(define) {
    return define(["widgets/js/manager", "widgets/js/widget", "jquery", "underscore", "backbone"], function(manager, widget, $, _, Backbone) {
      var CADView, api;
      CADView = (function(_super) {
        __extends(CADView, _super);

        function CADView() {
          this.update = __bind(this.update, this);
          this.hasCAD = __bind(this.hasCAD, this);
          this.frameLoaded = __bind(this.frameLoaded, this);
          this.render = __bind(this.render, this);
          return CADView.__super__.constructor.apply(this, arguments);
        }

        CADView.prototype.className = "ipcad CADView";

        CADView.prototype.render = function() {
          _.defer(this.update);
          this.viewModel = new Backbone.Model({
            cad: null,
            frame: null
          });
          this.viewModel.on({
            "change:cad": this.hasCAD
          });
          this.$frame = $("<iframe/>", {
            src: "/nbextensions/ipcad/CADViewFrame.html"
          });
          this.$frame.load(this.frameLoaded()).appendTo(this.$el);
          return this;
        };

        CADView.prototype.frameLoaded = function() {
          var view;
          view = this;
          return function(frame) {
            view.viewModel.set("frame", this);
            this.cadLoaded = (function(_this) {
              return function() {
                var cad;
                if (cad = _this.contentWindow.cad) {
                  view.viewModel.set("cad", cad);
                }
                return _.delay(_this.cadLoaded, 1000);
              };
            })(this);
            return this.cadLoaded();
          };
        };

        CADView.prototype.hasCAD = function() {
          return console.log(this.viewModel.get("cad"));
        };

        CADView.prototype.update = function(options) {
          return CADView.__super__.update.call(this, options);
        };

        return CADView;

      })(widget.DOMWidgetView);
      manager.WidgetManager.register_widget_view("CADView", CADView);
      return api = {
        CADView: CADView
      };
    });
  }).call(this, this.define);

}).call(this);