-module(mymap).
-export([
    mymap/2,
    call/0
]).

%-spec map()
mymap(Fu,List) ->
    PID = spawn(fun map2/0),
    ID = erlang:make_ref(),
    PID ! {self(),ID,List,Fu},
    receive
        {ID,ListDone} -> ok
    end,
    ListDone.

map2() ->
    receive
        {Parent,ID,List,Fu} -> ok
    end,
    case lists:flatlength(List) > 1 of
        false ->
            [Elem] = List,
            Parent ! {ID,[Fu(Elem)]};
        true ->
            PID1 = spawn(fun map2/0),
            PID2 = spawn(fun map2/0),
            {Left,Right} = lists:split(trunc(lists:flatlength(List)/2),List),
            ID1 = erlang:make_ref(),
            ID2 = erlang:make_ref(),
            PID1 ! {self(),ID1,Left,Fu},
            PID2 ! {self(),ID2,Right,Fu},
            receive
                {ID1,LeftDone} -> ok
            end,
            receive
                {ID2,RightDone} -> ok
            end,
            Parent ! {ID,LeftDone ++ RightDone}
    end.

f(X) ->
    X + 2.
call() ->
    mymap(fun f/1, [1,2,3,4]).