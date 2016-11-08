-module(pmap).
-export([
    pmap/2,
    example/1
]).

%-spec map()
pmap(Fu,List) ->
    PID = spawn(fun map2/0),
    ID = erlang:make_ref(),
    PID ! {self(),ID,List,Fu},
    receive
        {ID,ListDone} -> 
            ListDone;
        {ID, error, Reason} ->
            {error,Reason}
    end.

map2() ->
    receive
        {Parent,ID,List,Fu} -> ok
    end,
    case lists:flatlength(List) > 1 of
        false ->
            [Elem] = List,
            try Fu(Elem) of
                FApplied -> Parent ! {ID,[FApplied]}
            catch
                _:Reason -> 
                    Parent ! {ID, error, Reason}
            end;
        true ->
            PID1 = spawn(fun map2/0),
            PID2 = spawn(fun map2/0),
            {Left,Right} = lists:split(trunc(lists:flatlength(List)/2),List),
            ID1 = erlang:make_ref(),
            ID2 = erlang:make_ref(),
            PID1 ! {self(),ID1,Left,Fu},
            PID2 ! {self(),ID2,Right,Fu},
            {StateLeft, ResultLeft} = receive
                {ID1,LeftDone} -> {ok, LeftDone};
                {ID1,error,Reason1} ->
                    Parent ! {error, Reason1}
            end,
            {StateRight, ResultRight} = receive
                {ID2,RightDone} -> {ok, RightDone};
                {ID2,error,Reason2} ->
                    {error, Reason2}
            end,
            case {StateLeft,StateRight,ResultLeft,ResultRight} of
                {error,_,_,_} -> Parent ! {ID, error, ResultLeft};
                {_,error,_,_} -> Parent ! {ID, error, ResultRight};
                {ok,ok,_,_} -> Parent ! {ID, ResultLeft ++ ResultRight}
            end
    end.


% Examples

f(X) ->
    X + 2.
example(a) ->
    pmap(fun f/1, [1,2,3,4]);
example(b) ->
    pmap(fun (X) -> X + 2 end, [1,2,3,4]);
example(c) ->
    pmap(fun f/1, [1,2,"w",3]).