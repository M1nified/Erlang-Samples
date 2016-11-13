-module(example_SUITE).
-include_lib("eunit/include/eunit.hrl").

example_1_test() ->
    ?assert( 1 == 1).

example_2_test() ->
    ?assert( true ).

example_3_test() ->
    [
      ?assert( true ),
      ?assert( 1 == 1)
    ].

example_4_test() ->
    ?assertNot( true ).