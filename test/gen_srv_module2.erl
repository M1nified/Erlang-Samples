-module(gen_srv_module2).
-export([
    action/2,
    state/2,
    state_load/0,
    state_save/1
]).

-define(STATE_FILE,"gen_srv_module2_state_ignore").

action(Data,State) ->
    {module2action,{stare,Data},{state,State}}.

state(State,_) when is_number(State) ->
    State + 1;
state(_,_) ->
    0.

state_load() ->
    test_suite ! {called, {state_load,[]}},
    {error, test}.

state_save(_) ->
    {error, test}.
    
    
% test_suite ! test,