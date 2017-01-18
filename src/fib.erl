-module(fib).
-export([
    start/1
]).

fib(0,_,_) -> 
    [0, 0, 0];
fib(1,_,_) ->
    [1, 0, 1];
fib(N,First,Second) ->
    [First + Second, First, Second].

start(N) ->
    loop(N,0,0,0).

loop(0,_,_,_) -> ok;
loop(N,Iteration, PreFirst, PreSecond) ->
    [FibNum, First, Second] = fib(Iteration, PreFirst, PreSecond),
    io:fwrite("~p\t~p\n",[Iteration,FibNum]),
    loop(N-1,Iteration+1, Second, FibNum).

