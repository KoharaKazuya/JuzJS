// Generated by CoffeeScript 1.4.0
var JuzJS,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

JuzJS = (function() {
  var Connection, Controller, IDManager, JuzJSObject, Label, Node, PhysicsEngine, Preference, Vector, controller_cache, publish;
  Preference = (function() {

    function Preference() {}

    Preference.SEMITRANSPARENT = 0.3;

    Preference.SUPPORTED_EVENTS = ["click", "dblclick", "mousedown", "mouseup", "mousemove", "mouseover", "mouseout", "dragstart", "drag", "dragstop", "touchstart", "touchend", "touchmove"];

    Preference.REPLUSION_BASE = 1000000;

    Preference.GRAVITY_BASE = 0.01;

    Preference.UPDATE_SPEED = 0.02;

    Preference.MAX_UPDATABLE_NODES_NUM = 10;

    return Preference;

  })();
  JuzJSObject = (function() {

    function JuzJSObject(canvas, id) {
      this.canvas = canvas;
      this.id = id;
    }

    JuzJSObject.prototype.destroy = function() {
      return this.canvas.removeLayer(this.id);
    };

    JuzJSObject.prototype.getX = function() {
      return this.canvas.getLayer(this.id).x;
    };

    JuzJSObject.prototype.getY = function() {
      return this.canvas.getLayer(this.id).y;
    };

    JuzJSObject.prototype.setX = function(new_x) {
      return this.canvas.setLayer(this.id, {
        x: Math.round(new_x)
      });
    };

    JuzJSObject.prototype.setY = function(new_y) {
      return this.canvas.setLayer(this.id, {
        y: Math.round(new_y)
      });
    };

    return JuzJSObject;

  })();
  Node = (function(_super) {

    __extends(Node, _super);

    function Node(canvas, id, events) {
      var default_events, event, pref, _fn, _i, _len, _ref,
        _this = this;
      Node.__super__.constructor.call(this, canvas, id);
      pref = {
        name: this.id,
        type: "image",
        draggable: true,
        cursor: "pointer",
        opacity: Preference.SEMITRANSPARENT,
        group: "nodes"
      };
      default_events = {
        mouseover: function(layer) {
          return _this.appeal();
        }
      };
      _ref = Preference.SUPPORTED_EVENTS;
      _fn = function(event) {
        return pref[event] = function(layer) {
          var fn;
          fn = default_events[event];
          if (fn) {
            fn(layer);
          }
          fn = events[event];
          if (fn) {
            return fn(_this, layer.eventX, layer.eventY);
          }
        };
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        event = _ref[_i];
        _fn(event);
      }
      this.canvas.addLayer(pref);
      this.outConnections = {};
      this.inConnections = {};
    }

    Node.prototype.destroy = function() {
      var id, obj, _ref, _ref1, _results;
      Node.__super__.destroy.apply(this, arguments);
      _ref = this.outConnections;
      for (id in _ref) {
        obj = _ref[id];
        obj.connection.destroy();
        delete obj.node.inConnections[this.id];
      }
      _ref1 = this.inConnections;
      _results = [];
      for (id in _ref1) {
        obj = _ref1[id];
        obj.connection.destroy();
        _results.push(delete obj.node.outConnections[this.id]);
      }
      return _results;
    };

    Node.prototype.setIcon = function(src, options) {
      var layer;
      layer = this.canvas.getLayer(this.id);
      return layer.source = src;
    };

    Node.prototype.setX = function(new_x) {
      var icon_width, id, obj, _ref, _ref1, _results;
      icon_width = this.canvas.getLayer(this.id).width / 2;
      new_x = Math.min(Math.max(icon_width, new_x), this.canvas.width() - icon_width);
      Node.__super__.setX.call(this, new_x);
      _ref = this.outConnections;
      for (id in _ref) {
        obj = _ref[id];
        obj.connection.setSrcX(new_x);
      }
      _ref1 = this.inConnections;
      _results = [];
      for (id in _ref1) {
        obj = _ref1[id];
        _results.push(obj.connection.setDestX(new_x));
      }
      return _results;
    };

    Node.prototype.setY = function(new_y) {
      var icon_height, id, obj, _ref, _ref1, _results;
      icon_height = this.canvas.getLayer(this.id).height / 2;
      new_y = Math.min(Math.max(icon_height, new_y), this.canvas.height() - icon_height);
      Node.__super__.setY.call(this, new_y);
      _ref = this.outConnections;
      for (id in _ref) {
        obj = _ref[id];
        obj.connection.setSrcY(new_y);
      }
      _ref1 = this.inConnections;
      _results = [];
      for (id in _ref1) {
        obj = _ref1[id];
        _results.push(obj.connection.setDestY(new_y));
      }
      return _results;
    };

    Node.prototype.getGravity = function(other) {
      var ins, outs;
      outs = this.outConnections[other.id];
      if (outs) {
        return outs.connection.strength;
      }
      ins = this.inConnections[other.id];
      if (ins) {
        return ins.connection.strength;
      }
      return 0;
    };

    Node.prototype.connect = function(other, strength, text, text_options) {
      var con, id;
      this.disconnect(other);
      id = "from_" + this.id + "_to_" + other.id;
      con = new Connection(this.canvas, id, strength, new Label(this.canvas, id + "_label", text, text_options));
      this.outConnections[other.id] = {
        node: other,
        connection: con
      };
      return other.inConnections[this.id] = {
        node: this,
        connection: con
      };
    };

    Node.prototype.disconnect = function(other) {
      if ((other.id in this.outConnections) && (this.id in other.inConnections)) {
        this.outConnections[other.id].connection.destroy();
        delete this.outConnections[other.id];
        delete other.inConnections[this.id];
      }
      if ((other.id in this.inConnections) && (this.id in other.outConnections)) {
        this.inConnections[other.id].connection.destroy();
        delete this.inConnections[other.id];
        return delete other.outConnections[this.id];
      }
    };

    Node.prototype.appeal = function() {
      var id, last, v, _ref, _ref1, _ref2, _ref3, _results;
      this.canvas.setLayerGroup("nodes", {
        opacity: Preference.SEMITRANSPARENT
      });
      last = this.canvas.getLayers().length - 1;
      _ref = this.outConnections;
      for (id in _ref) {
        v = _ref[id];
        this.canvas.setLayer(id, {
          opacity: 1
        });
        this.canvas.moveLayer(id, last);
      }
      _ref1 = this.inConnections;
      for (id in _ref1) {
        v = _ref1[id];
        this.canvas.setLayer(id, {
          opacity: 1
        });
        this.canvas.moveLayer(id, last);
      }
      this.canvas.setLayer(this.id, {
        opacity: 1
      });
      this.canvas.moveLayer(this.id, last);
      this.canvas.setLayerGroup("connections", {
        opacity: Preference.SEMITRANSPARENT
      });
      this.canvas.setLayerGroup("labels", {
        opacity: Preference.SEMITRANSPARENT
      });
      _ref2 = this.outConnections;
      for (id in _ref2) {
        v = _ref2[id];
        v.connection.appeal();
      }
      _ref3 = this.inConnections;
      _results = [];
      for (id in _ref3) {
        v = _ref3[id];
        _results.push(v.connection.appeal());
      }
      return _results;
    };

    return Node;

  })(JuzJSObject);
  IDManager = (function() {

    function IDManager() {}

    IDManager.prototype.jcanvas_id_counter = 0;

    IDManager.prototype.getJCanvasUniqueName = function() {
      return "jCanvas_id_" + this.jcanvas_id_counter++;
    };

    return IDManager;

  })();
  PhysicsEngine = (function() {

    function PhysicsEngine() {}

    PhysicsEngine.prototype.update = function(nodeList, canvas) {
      var centerizeVector, forceList, gravityVector, list, node, r, replusionVector, updateList, _i, _ref, _results;
      if (nodeList.length > Preference.MAX_UPDATABLE_NODES_NUM) {
        updateList = [];
        list = (function() {
          _results = [];
          for (var _i = 0, _ref = nodeList.length; 0 <= _ref ? _i < _ref : _i > _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
          return _results;
        }).apply(this);
        while (updateList.length < Preference.MAX_UPDATABLE_NODES_NUM) {
          r = Math.floor(Math.random() * list.length);
          updateList.push(nodeList[list[r]]);
          list.splice(r, 1);
        }
      } else {
        updateList = nodeList;
      }
      forceList = (function() {
        var _j, _len, _results1;
        _results1 = [];
        for (_j = 0, _len = updateList.length; _j < _len; _j++) {
          node = updateList[_j];
          replusionVector = this.computeReplusion(node, nodeList);
          gravityVector = this.computeGravity(node, nodeList);
          centerizeVector = this.computeCenterize(node, canvas);
          _results1.push(replusionVector.add(gravityVector).add(centerizeVector));
        }
        return _results1;
      }).call(this);
      return this.updatePosition(updateList, forceList);
    };

    PhysicsEngine.prototype.computeReplusion = function(node, nodeList) {
      var div, other, v, vect, _i, _len;
      v = new Vector(0, 0);
      for (_i = 0, _len = nodeList.length; _i < _len; _i++) {
        other = nodeList[_i];
        if (node === other) {
          continue;
        }
        vect = this.point2Vector(node).sub(this.point2Vector(other));
        div = Math.pow(vect.getScalar(), 2);
        if (div === 0) {
          v = v.add(Vector.polar2rect(Preference.REPLUSION_BASE, 2 * Math.PI * Math.random()));
        } else {
          v = v.add(Vector.polar2rect(Preference.REPLUSION_BASE / div, vect.getAngle()));
        }
        v = this.limitedForce(v);
      }
      return v;
    };

    PhysicsEngine.prototype.computeGravity = function(node, nodeList) {
      var g, other, v, vect, _i, _len;
      v = new Vector(0, 0);
      for (_i = 0, _len = nodeList.length; _i < _len; _i++) {
        other = nodeList[_i];
        if (node === other) {
          continue;
        }
        g = node.getGravity(other);
        if (g === 0) {
          continue;
        }
        vect = this.point2Vector(other).sub(this.point2Vector(node));
        v = v.add(Vector.polar2rect(g * Preference.GRAVITY_BASE * Math.pow(vect.getScalar(), 2), vect.getAngle()));
        v = this.limitedForce(v);
      }
      return v;
    };

    PhysicsEngine.prototype.computeCenterize = function(node, canvas) {
      var center_x, center_y;
      center_x = canvas.attr("width") / 2;
      center_y = canvas.attr("height") / 2;
      return new Vector(center_x, center_y).sub(this.point2Vector(node));
    };

    PhysicsEngine.prototype.limitedForce = function(vector) {
      vector.x = Math.min(Math.max(-1000, vector.x), 1000);
      vector.y = Math.min(Math.max(-1000, vector.y), 1000);
      return vector;
    };

    PhysicsEngine.prototype.updatePosition = function(nodeList, forceList) {
      var force, i, node, _i, _ref, _results;
      _results = [];
      for (i = _i = 0, _ref = nodeList.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        node = nodeList[i];
        force = forceList[i];
        node.setX(node.getX() + force.x * Preference.UPDATE_SPEED);
        _results.push(node.setY(node.getY() + force.y * Preference.UPDATE_SPEED));
      }
      return _results;
    };

    PhysicsEngine.prototype.point2Vector = function(node) {
      return new Vector(node.getX(), node.getY());
    };

    return PhysicsEngine;

  })();
  Vector = (function() {

    function Vector(x, y) {
      this.x = x;
      this.y = y;
    }

    Vector.prototype.getScalar = function() {
      return Math.sqrt(Math.pow(this.x, 2) + Math.pow(this.y, 2));
    };

    Vector.prototype.getAngle = function() {
      if (this.x === 0 && this.y === 0) {
        return 0;
      } else if (this.x === 0) {
        if (this.y < 0) {
          return -Math.PI / 2;
        } else {
          return Math.PI / 2;
        }
      } else if (this.y === 0) {
        if (this.x < 0) {
          return Math.PI;
        } else {
          return 0;
        }
      } else {
        if (this.x < 0) {
          return Math.atan(this.y / this.x) + Math.PI;
        } else {
          return (Math.atan(this.y / this.x) + Math.PI * 2) % (Math.PI * 2);
        }
      }
    };

    Vector.prototype.add = function(other) {
      return new Vector(this.x + other.x, this.y + other.y);
    };

    Vector.prototype.sub = function(other) {
      return new Vector(this.x - other.x, this.y - other.y);
    };

    return Vector;

  })();
  Vector.polar2rect = function(scalar, angle) {
    var new_x, new_y;
    new_x = scalar * Math.cos(angle);
    new_y = scalar * Math.sin(angle);
    return new Vector(new_x, new_y);
  };
  Connection = (function(_super) {

    __extends(Connection, _super);

    function Connection(canvas, id, strength, label) {
      this.strength = strength;
      this.label = label;
      Connection.__super__.constructor.call(this, canvas, id);
      this.canvas.drawLine({
        layer: true,
        name: this.id,
        index: 0,
        group: "connections",
        strokeStyle: "black"
      });
      this.setSrcX(0);
      this.setSrcY(0);
      this.setDestX(0);
      this.setDestY(0);
    }

    Connection.prototype.destroy = function() {
      Connection.__super__.destroy.call(this);
      return this.label.destroy();
    };

    Connection.prototype.getX = function() {
      throw "this function is disabled in Connection";
    };

    Connection.prototype.getY = function() {
      throw "this function is disabled in Connection";
    };

    Connection.prototype.setX = function(new_x) {
      throw "this function is disabled in Connection";
    };

    Connection.prototype.setY = function(new_y) {
      throw "this function is disabled in Connection";
    };

    Connection.prototype.getSrcX = function() {
      return this.canvas.getLayer(this.id).x1;
    };

    Connection.prototype.getSrcY = function() {
      return this.canvas.getLayer(this.id).y1;
    };

    Connection.prototype.getDestX = function() {
      return this.canvas.getLayer(this.id).x2;
    };

    Connection.prototype.getDestY = function() {
      return this.canvas.getLayer(this.id).y2;
    };

    Connection.prototype.setSrcX = function(value) {
      this.canvas.setLayer(this.id, {
        x1: value
      });
      return this.labelUpdate();
    };

    Connection.prototype.setSrcY = function(value) {
      this.canvas.setLayer(this.id, {
        y1: value
      });
      return this.labelUpdate();
    };

    Connection.prototype.setDestX = function(value) {
      this.canvas.setLayer(this.id, {
        x2: value
      });
      return this.labelUpdate();
    };

    Connection.prototype.setDestY = function(value) {
      this.canvas.setLayer(this.id, {
        y2: value
      });
      return this.labelUpdate();
    };

    Connection.prototype.labelUpdate = function() {
      var layer;
      layer = this.canvas.getLayer(this.id);
      this.label.setX((layer.x1 + layer.x2) / 2);
      return this.label.setY((layer.y1 + layer.y2) / 2);
    };

    Connection.prototype.appeal = function() {
      this.canvas.setLayer(this.id, {
        opacity: 1
      });
      return this.label.appeal();
    };

    return Connection;

  })(JuzJSObject);
  Label = (function(_super) {

    __extends(Label, _super);

    function Label(canvas, id, text, options) {
      var pref;
      Label.__super__.constructor.call(this, canvas, id);
      pref = {
        layer: true,
        name: this.id,
        group: "labels",
        text: text,
        fromCenter: true,
        opacity: Preference.SEMITRANSPARENT
      };
      if (options != null) {
        if (options.color != null) {
          pref.fillStyle = options.color;
        }
        if (options.style != null) {
          pref.font = options.style;
        }
        if (options.width != null) {
          pref.maxWidth = options.width;
        }
        if (options.scaleOnMouseout != null) {
          pref.scale = options.scaleOnMouseout;
          pref.mouseover = function(_) {
            return _.scale = 1;
          };
          pref.mouseout = function(_) {
            return _.scale = options.scaleOnMouseout;
          };
        }
      } else {
        pref.fillStyle = "black";
        pref.font = "20pt sans-serif";
        pref.scale = 0.5;
        pref.mouseover = function(_) {
          return _.scale = 1;
        };
        pref.mouseout = function(_) {
          return _.scale = 0.5;
        };
      }
      this.canvas.drawText(pref);
    }

    Label.prototype.appeal = function() {
      this.canvas.setLayer(this.id, {
        opacity: 1
      });
      return this.canvas.moveLayer(this.id, this.canvas.getLayers().length - 1);
    };

    return Label;

  })(JuzJSObject);
  Controller = (function() {

    function Controller(canvas, engine) {
      this.canvas = canvas;
      this.engine = engine;
      this.nodeList = [];
      this.IDManager = new IDManager();
      this.start();
    }

    Controller.prototype.createNode = function(events) {
      var node;
      node = new Node(this.canvas, this.IDManager.getJCanvasUniqueName(), events);
      this.nodeList.push(node);
      return node;
    };

    Controller.prototype.removeNode = function(node) {
      var index;
      index = this.nodeList.indexOf(node);
      if (index === -1) {
        throw new Error("削除するように指定したノードが見つかりません");
      }
      this.nodeList = this.nodeList.slice(0, index).concat(this.nodeList.slice(index + 1, this.nodeList.length));
      return node.destroy();
    };

    Controller.prototype.start = function() {
      var _this = this;
      return this.updater = setInterval(function() {
        _this.engine.update(_this.nodeList, _this.canvas);
        return _this.canvas.drawLayers();
      }, 1000 / 60);
    };

    Controller.prototype.stop = function() {
      return clearInterval(this.updater);
    };

    return Controller;

  })();
  controller_cache = {};
  return publish = function(canvas_selector) {
    var _ref;
    return (_ref = controller_cache[canvas_selector]) != null ? _ref : controller_cache[canvas_selector] = new Controller($(canvas_selector), new PhysicsEngine());
  };
})();