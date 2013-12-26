Rina
====

Rina Is Not AMD (Asynchronous Module Definition).

Rina Is A Synchronous JavaScript Module Definition, compatible with optimized files produced using AMD format.


Why Rina?
----
AMD is a very instructive guidance, providing a better way for encapsulating complex javascripts in the web today. But ideally, It required you to put modules into each separate file, then dynamic load module once needed.

But in the real world, I usually packaged multiple small js into one big file, gzipped, cached, and delivered by cdn. Path resolving is also a another con to me in some cases (like rails sprockets).

Require.js also features an optimizer, to bundle all used modules into one single file.

But here is Rina, A smaller and more flexible implementation.
