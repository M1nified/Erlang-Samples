-module(pmap_SUITE).
-include_lib("eunit/include/eunit.hrl").

pmap__1_test() ->
    [3,4,5,6] = pmap:pmap(fun (X) -> X + 2 end, [1,2,3,4]),
    ["A","B","C"] = pmap:pmap(fun (X) -> string:to_upper(X) end, ["a","b","C"]).
pmap__2_test() ->
    {error, badarith} = pmap:pmap(fun (X) -> X + 2 end, [1,2,"w",4]).
pmap__3_test() ->
    {error, {badfun,2}} = pmap:pmap(2, [1,2,3,4]).
