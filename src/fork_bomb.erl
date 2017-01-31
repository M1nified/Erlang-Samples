-module(fork_bomb).
-export([
  start/0
]).

start() ->
  Pids = [ spawn(fun start/0) || _ <- lists:seq(1,10) ],
  loop(Pids).

loop(Pids) ->
  lists:foreach(fun(Pid) -> Pid ! {starting_pids, Pids} end, Pids),
  loop(Pids).
