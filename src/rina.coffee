###
Rina 0.0.1
Copyright (c) 2013-2014 aligo Kang

Released under the MIT license
http://opensource.org/licenses/mit-license.php
###

resolved_modules = {}
unresolved_modules = {}
required_links = {}

original_define = window.define
original_require = window.require

rina = 
  define: (name, deps, module_fn) ->
    if typeof deps is 'function'
      module_fn = deps
      deps = []
    else if typeof deps is 'string'
      deps = [deps]

    if resolved_modules[name] or unresolved_modules[name]
      throw new Error('Rina - duplicate definition for module: "' + name + '".')

    _try_define name, deps, module_fn

  require: ->
    if arguments.length > 2
      deps = arguments
    else
      deps = arguments[0]
      fn = arguments[1]
      if typeof deps is 'string'
        deps = [deps]
      if typeof fn is 'string'
        deps.push fn
        fn = false
    
    result = _resolve_deps deps, ( (resolved_deps) ->
      fn.apply {}, resolved_deps if fn
    ), ( (unresolved_deps) ->
      message = 'Rina -'
      real_undefined_deps = []
      real_unresolved_deps = []
      for dep in unresolved_deps
        if unresolved_modules[dep]
          real_unresolved_deps.push '"' + dep + '"=>"' + unresolved_modules[dep].unresolved_deps.join(',') + '"'
        else
          real_undefined_deps.push '"' + dep + '"'
      if real_undefined_deps.length > 0
        message += ' undefined module(s): ' + real_undefined_deps.join(', ') + '.'
      if real_unresolved_deps.length > 0
        message += ' unresolved module(s): ' + real_unresolved_deps.join(', ') + '.'
      throw new Error(message)
    )
    result = result[0] if result.length == 1
    result

  noConflict: ->
    window.define = original_define
    window.require = original_require
    rina


_resolve_deps = (deps, resolved, unresolved) ->
  resolved_deps = []
  unresolved_deps = []

  for dep in deps
    if resolved_modules[dep]
      resolved_deps.push resolved_modules[dep]
    else
      unresolved_deps.push dep

  if unresolved_deps.length == 0
    resolved.apply {}, [resolved_deps]
  else
    unresolved.apply {}, [unresolved_deps]

  resolved_deps

_try_define = (name, deps, module_fn) ->
  _resolve_deps deps, ( (resolved_deps) ->
    resolved_modules[name] = module_fn.apply {}, resolved_deps
    if required_links[name]
      for link in required_links[name]
        idx = unresolved_modules[link].unresolved_deps.indexOf name
        unresolved_modules[link].unresolved_deps.splice idx, 1 if idx != -1
        if unresolved_modules[link].unresolved_deps.length == 0
          _try_define link, unresolved_modules[link].deps, unresolved_modules[link].module_fn
      delete required_links[name]
  ), ( (unresolved_deps) ->
    unresolved_modules[name] =
      deps: deps
      unresolved_deps: unresolved_deps
      module_fn: module_fn
    for dep in unresolved_deps
      required_links[dep] ||= []
      required_links[dep].push name
  )


window.rina = rina
window.define = rina.define
window.require = rina.require