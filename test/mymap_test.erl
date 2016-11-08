-module(mymap_test).
-include_lib("eunit/include/eunit.hrl").

mymap_test() ->
    [3,4,5,6] = mymap:mymap(fun (X) -> X + 2 end, [1,2,3,4]).