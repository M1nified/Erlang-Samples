-module(tempconv).
-export([
    convert_seq/3,
    convert_con/3
]).

% convert_seq(Val,In,Out) ->
convert_seq(Val,c,k) ->
    Val + 237.15.


convert_con(Val,In,Out) ->
    PID = spawn(fun convert_con_thread/0),
    Safe = erlang:mk_ref(),
    PID ! {self(),Safe,Val,In,Out},
    receive
        {PID,Safe,Score} -> true
    end,
    Score.


convert_con_thread()->
    receive
        {Parent,Safe,Val,In,Out} ->
            Parent ! {self(),Safe,convert_seq(Val,In,Out)}
    end.
