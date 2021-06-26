Todo
====

*Wow, such empty*

Done
====

 - document global injections
 - update test suite
 - timeout option
 - cleanup API and fix state bug (using require the state is conserved between tests runs)
 - fix readme image
 - exit codes
 - implement TAP reporter https://testanything.org/. Not relevant in the OC context
 - traceback display if needed
 - do I need the trace outside of the coroutine? (see comment)
 - implement OpenPrograms
 - what happens when overflow max color depth? (it displays all the colors)
 - functions that have multiples returns
 - recursive `describe()`. Nop, to much hassle! https://medium.com/better-programming/yagni-you-aint-gonna-need-it-f9a178cd8e1
 - limit depth to 8 to avoid stack overflow errors and misusage (see task above)
 - document API using ldoc
 - pass stack (numbers) arguments to functions
 - pass heap (objects, functions) arguments to functions
 - before, after, beforeEach and afterEach support
 - mock api for cross-platform testing. Nop, just test in OpenComputers, don'treimplement the reimplementation :)