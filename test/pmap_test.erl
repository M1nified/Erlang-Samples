-module(pmap_test).
-include_lib("eunit/include/eunit.hrl").

pmap__1_test() ->
    [3,4,5,6] = pmap:pmap(fun (X) -> X + 2 end, [1,2,3,4]).
pmap__2_test() ->
    {error, badarith} = pmap:pmap(fun (X) -> X + 2 end, [1,2,"w",4]).