-module(gen_srv_SUITE).
-include_lib("eunit/include/eunit.hrl").

call_should_send_back__test() ->
    Srv = gen_srv:init(gen_srv_module1),
    Ref = make_ref(),
    Srv ! {call, self(),Ref,jakies_info},
    receive
        {Ref,{module1action,{stare,jakies_info},{state,_}}} -> ok;
        Any -> ct:fail({1,Any})
    end.

call_should_change_module__test() ->
    Srv = gen_srv:init(gen_srv_module1),
    Ref = make_ref(),
    Srv ! {update, self(),Ref,gen_srv_module2},
    Srv ! {call, self(),Ref,jakies_info},
    receive
        {Ref,{module2action,{stare,jakies_info},{state,_}}} -> ok;
        Any -> ct:fail({1,Any})
    end.

init_should_load_state__test() ->
    erlang:register(test_suite,self()),
    _ = gen_srv:init(gen_srv_module2),
    receive
        {called, {state_load,[]}}  -> ok;
        Any1 -> ct:fail(Any1)
    after 1000 -> ct:fail({timeout,1})
    end.
