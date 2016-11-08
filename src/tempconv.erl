-module(tempconv).
-export([
    convert_seq/3,
    convert_con/3
]).

% convert_seq(Val,In,Out)
% http://www.rapidtables.com/convert/temperature/celsius-to-fahrenheit.htm
% c - Celsius
% k - Kelvin
% f - Fahrenheit
% r - Rankine
convert_seq(Val,c,f) -> Val * 9 / 5 + 32;
convert_seq(Val,c,k) -> Val + 273.15;
convert_seq(Val,c,r) -> convert_seq(convert_seq(Val,c,k),k,r); %convert_seq(Val,c,k) * 9 / 5;

convert_seq(Val,f,c) -> (Val - 32) * 5 / 9;
convert_seq(Val,f,k) -> convert_seq(convert_seq(Val,f,r),r,k); %convert_seq(Val,f,r) * 5 / 9;
convert_seq(Val,f,r) -> Val + 459.67;

convert_seq(Val,k,f) -> convert_seq(convert_seq(Val,k,r),r,f); %convert_seq(Val,k,r) - 459.67;
convert_seq(Val,k,c) -> Val - 273.15;
convert_seq(Val,k,r) -> Val * 9 / 5;

convert_seq(Val,r,c) -> (Val - 491.67) * 5 / 9;
convert_seq(Val,r,f) -> Val - 459.67;
convert_seq(Val,r,k) -> Val * 5 / 9.

convert_con(Val,In,Out) ->
    PID = spawn(fun convert_con_thread/0),
    Safe = erlang:make_ref(), %unique reference to ensure correct data transfer
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
