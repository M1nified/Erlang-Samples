-module(gen_srv_module2).
-export([
    action/2,
    state/2
]).

action(Data,State) ->
    {module2action,{stare,Data},{state,State}}.

state(State,_) when is_number(State) ->
    State + 1;
state(_,_) ->
    0.