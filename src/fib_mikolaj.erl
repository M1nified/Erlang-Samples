-module(fib_mikolaj).
-export([
    start/1
]).

fib(1,0,0) -> 0;
fib(1,0,1) -> 1;
fib(N,N1,0) ->
    N;
fib(N,N1,Loop) ->
    fib(N+N1,N,Loop-1).

start(X) ->
    fib(1,0,X).