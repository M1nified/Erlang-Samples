-module(zad1).
-export([
    randlist/1
]).

randlist(Num) -> [random:uniform(100) || _ <- lists:seq(1, Num)].
