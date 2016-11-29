-module(gen_srv_module2).
-export([
    action/2,
    state/2,
    state_load/0,
    state_save/1
]).

-define(STATE_FILE,"gen_srv_module1_state_ignore").

action(Data,State) ->
    {module2action,{stare,Data},{state,State}}.

state(State,_) when is_number(State) ->
    State + 1;
state(_,_) ->
    0.

state_load() ->
    case file:read_file(?STATE_FILE) of
        {ok, Binary} ->
            {ok, binary_to_term(Binary)};
        {error, Reason} ->
            {error, Reason}
    end.

state_save(State) ->
    file:write_file(?STATE_FILE,term_to_binary(State)).