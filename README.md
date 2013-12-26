Rina
====

Rina Is Not AMD (Asynchronous Module Definition).

Rina Is A Synchronous JavaScript Module Definition, compatible with optimized files produced using AMD format.

Why Rina?
----
AMD is a very instructive guidance, providing a better way for encapsulating complex javascripts in the web today. But ideally, It required you to put modules into each separate file, then dynamic load module once needed.

But in the real world, I usually packaged multiple small js into one big file, gzipped, cached, and delivered by cdn. Path resolving is also a another con to me in some cases (like rails sprockets, BTW I has been used requirejs-rails in a big project, which required me a four-pages requirejs.yml, it's too over).

Require.js also features an optimizer, to bundle all used modules into one single file.

But here is Rina, A smaller and more flexible implementation.

----

Basically, usage is exactly the same as AMD:
```javascript
define(['jquery'] , function ($) {
    return function () {};
});
define('myModuleWithSomeLongLongNamespace', ['underscore'] , function (_) {
    return function () {};
});
require(['myModuleWithSomeLongLongNamespace', 'underscore'], function (myModule, _) {
    return function () {};
});
```

Cause of it's not asynchronous, you may want to do that AMD can't:
```javascript
myModule = require('myModuleWithSomeLongLongNamespace');
```

And more examples in: https://github.com/aligo/rina/blob/master/test/test.coffee

----

### Downloads
[Production Version (~1kb)](https://raw.github.com/aligo/rina/master/build/rina.min.js)

[Development Version (~2kb)](https://raw.github.com/aligo/rina/master/build/rina.js)

### Version
0.0.1

----
#### Author
aligo Kang <aligo_x@163.com>

#### License
MIT License
