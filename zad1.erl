-module(zad1).
-export([
    randlist/1,
    qsort/1,
    benchmarksort/0
]).

% list lenght
% len([]) -> 0;
% len(List) -> len(List,0).

% len([],Len) -> Len;
% len([_|Tail],Len) -> len(Tail,Len+1). 

randlist(Num) -> [random:uniform(100) || _ <- lists:seq(1, Num)].

qsort([]) -> [];
qsort([Pivot|T]) ->
    qsort([X || X <- T, X < Pivot])
    ++ [Pivot] ++
    qsort([X || X <- T, X >= Pivot]).

% sort(Parent,List) ->
%     if len(List)>2  
%         % split
%     else
%         % sort & send

benchmarksort()->
    benchmark:test_avg(zad1,qsort,[randlist(100)],10).
