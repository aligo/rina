// Generated by CoffeeScript 1.6.3
/*
Rina 0.0.1
Copyright (c) 2013-2014 aligo Kang

Released under the MIT license
http://opensource.org/licenses/mit-license.php
*/


(function() {
  var original_define, original_require, required_links, resolved_modules, rina, unresolved_modules, _resolve_deps, _try_define;

  resolved_modules = {};

  unresolved_modules = {};

  required_links = {};

  original_define = window.define;

  original_require = window.require;

  rina = {
    define: function(name, deps, module_fn) {
      if (typeof deps === 'function') {
        module_fn = deps;
        deps = [];
      } else if (typeof deps === 'string') {
        deps = [deps];
      }
      if (resolved_modules[name] || unresolved_modules[name]) {
        throw new Error('Rina - duplicate definition for module: "' + name + '".');
      }
      return _try_define(name, deps, module_fn);
    },
    require: function() {
      var deps, fn, result;
      if (arguments.length > 2) {
        deps = arguments;
      } else {
        deps = arguments[0];
        fn = arguments[1];
        if (typeof deps === 'string') {
          deps = [deps];
        }
        if (typeof fn === 'string') {
          deps.push(fn);
          fn = false;
        }
      }
      result = _resolve_deps(deps, (function(resolved_deps) {
        if (fn) {
          return fn.apply({}, resolved_deps);
        }
      }), (function(unresolved_deps) {
        var dep, message, real_undefined_deps, real_unresolved_deps, _i, _len;
        message = 'Rina -';
        real_undefined_deps = [];
        real_unresolved_deps = [];
        for (_i = 0, _len = unresolved_deps.length; _i < _len; _i++) {
          dep = unresolved_deps[_i];
          if (unresolved_modules[dep]) {
            real_unresolved_deps.push('"' + dep + '"=>"' + unresolved_modules[dep].unresolved_deps.join(',') + '"');
          } else {
            real_undefined_deps.push('"' + dep + '"');
          }
        }
        if (real_undefined_deps.length > 0) {
          message += ' undefined module(s): ' + real_undefined_deps.join(', ') + '.';
        }
        if (real_unresolved_deps.length > 0) {
          message += ' unresolved module(s): ' + real_unresolved_deps.join(', ') + '.';
        }
        throw new Error(message);
      }));
      if (result.length === 1) {
        result = result[0];
      }
      return result;
    },
    noConflict: function() {
      window.define = original_define;
      window.require = original_require;
      return rina;
    }
  };

  _resolve_deps = function(deps, resolved, unresolved) {
    var dep, resolved_deps, unresolved_deps, _i, _len;
    resolved_deps = [];
    unresolved_deps = [];
    for (_i = 0, _len = deps.length; _i < _len; _i++) {
      dep = deps[_i];
      if (resolved_modules[dep]) {
        resolved_deps.push(resolved_modules[dep]);
      } else {
        unresolved_deps.push(dep);
      }
    }
    if (unresolved_deps.length === 0) {
      resolved.apply({}, [resolved_deps]);
    } else {
      unresolved.apply({}, [unresolved_deps]);
    }
    return resolved_deps;
  };

  _try_define = function(name, deps, module_fn) {
    return _resolve_deps(deps, (function(resolved_deps) {
      var idx, link, _i, _len, _ref;
      resolved_modules[name] = module_fn.apply({}, resolved_deps);
      if (required_links[name]) {
        _ref = required_links[name];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          link = _ref[_i];
          idx = unresolved_modules[link].unresolved_deps.indexOf(name);
          if (idx !== -1) {
            unresolved_modules[link].unresolved_deps.splice(idx, 1);
          }
          if (unresolved_modules[link].unresolved_deps.length === 0) {
            _try_define(link, unresolved_modules[link].deps, unresolved_modules[link].module_fn);
          }
        }
        return delete required_links[name];
      }
    }), (function(unresolved_deps) {
      var dep, _i, _len, _results;
      unresolved_modules[name] = {
        deps: deps,
        unresolved_deps: unresolved_deps,
        module_fn: module_fn
      };
      _results = [];
      for (_i = 0, _len = unresolved_deps.length; _i < _len; _i++) {
        dep = unresolved_deps[_i];
        required_links[dep] || (required_links[dep] = []);
        _results.push(required_links[dep].push(name));
      }
      return _results;
    }));
  };

  window.rina = rina;

  window.define = rina.define;

  window.require = rina.require;

}).call(this);