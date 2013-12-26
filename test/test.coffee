define 'testModule1', ->
  'module1'
define 'testModule2', ->
  'module2'
define 'testModule3', ->
  'module3'

module 'require'
test 'Should throw when requires undefined module', ->
  throws (->
    require ['undefinedModule'], (dummy) ->
      #
  ), 'Rina - undefined module(s): "undefinedModule".' , 'ok'

test 'Should throw when requires unresolved module', ->
  define 'unresolvedModule', ['undefinedModule2'], (dummy) ->
    #
  throws (->
    require ['unresolvedModule'], (dummy) ->
      #
  ), 'Rina - unresolved module(s): "unresolvedModule"=>"undefinedModule2".' , 'ok'

test 'Should can defines modules without deps then requires them', ->
  require ['testModule2', 'testModule1'], (m2, m1) ->
    equal m1, 'module1', 'testModule1 ok'
    equal m2, 'module2', 'testModule2 ok'

test 'Should can requires module then directly asssert', ->
  equal require('testModule1'), 'module1', 'single testModule1 ok'
  deepEqual require('testModule1', 'testModule2'), ['module1', 'module2'], 'multiple modules 1 ok'
  deepEqual require(['testModule2', 'testModule1', 'testModule3']), ['module2', 'module1', 'module3'], 'multiple modules 2 ok'
  deepEqual require('testModule2', 'testModule1', 'testModule3'), ['module2', 'module1', 'module3'], 'multiple modules 3 ok'

module 'define'
test 'Should can use as require', ->
  require ['testModule2', 'testModule1'], (m2, m1) ->
    equal m1, 'module1', 'testModule1 ok'
    equal m2, 'module2', 'testModule2 ok'

test 'Should throw when duplicate definition', ->
  throws (->
    define 'testModule1', ->
      'module1'
  ), /Rina - duplicate definition for module/ , 'ok'

test 'Should can resolves defined deps when definition', ->
  define 'testModule4', 'testModule3', (m3) ->
    m3.replace '3', '4'

  define 'testModule5', ['testModule4', 'testModule1'], (m4, m1) ->
    m1 + m4

  equal require('testModule4'), 'module4', 'ok'
  equal require('testModule5'), 'module1module4', 'ok'

test 'Should can delay resolves undefined deps when definition 1', ->
  define 'testModule6', ['testModule7', 'testModule1'], (m7, m1) ->
    m1 + m7

  define 'testModule7', ->
    'module7'

  equal require('testModule6'), 'module1module7', 'ok'

test 'Should can delay resolves undefined deps when definition 2', ->
  define 'testModule8', ['testModule9', 'testModule10'], (m9, m10) ->
    m9 + m10

  define 'testModule9', ['testModule10'], (m10, m11) ->
    'module9'

  define 'testModule10', () ->
    'module10'

  define 'testModule11', ['testModule8'], (m8) ->
    m8

  equal require('testModule8'), 'module9module10', 'ok'
  equal require('testModule11'), 'module9module10', 'ok'