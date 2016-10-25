-module(qsort).
-export([
    randlist/1,
    qsort_seq/1,
    qsort_concurrent/1,
    benchmark_sort_seq/0,
    benchmark_sort_conc/0,
    benchmark_sort_both/0
]).

% list lenght
len([]) -> 0;
len(List) -> len(List,0).

len([],Len) -> Len;
len([_|Tail],Len) -> len(Tail,Len+1). 

randlist(Num) -> [random:uniform(100) || _ <- lists:seq(1, Num)].

qsort_seq([]) -> [];
qsort_seq([Pivot|T]) ->
    qsort_seq([X || X <- T, X < Pivot])
    ++ [Pivot] ++
    qsort_seq([X || X <- T, X >= Pivot]).


% https://www.safaribooksonline.com/library/view/erlang-programming/9780596803940/ch04s03.html
qsort_concurrent_listener() ->
    receive
        {List,PID_Parent,Side} ->
            case len(List) =< 2 of
                true -> 
                    % io_lib:format("~w",[List]),
                    PID_Parent ! {Side,qsort_seq(List)};
                false ->
                    io_lib:format("~w",[List]),
                    PID_left = spawn(fun qsort_concurrent_listener/0),
                    PID_right = spawn(fun qsort_concurrent_listener/0),
                    PID = self(),
                    {Left,Right} = lists:split(trunc(len(List)/2),List),

                    PID_left ! {Left,PID,left},
                    PID_right ! {Right,PID,right},
                    receive
                        {left,LeftSorted} -> true
                    end,
                    receive
                        {right,RightSorted} -> true
                    end,
                    PID_Parent ! {Side,lists:merge(LeftSorted,RightSorted)}
            end
    end.
qsort_concurrent(List) ->
    Sort = spawn(fun qsort_concurrent_listener/0),
    Sort ! {List,self(),left},
    receive
        {left,ListSorted} -> true
    end,
    ListSorted.

benchmark_sort_seq()->
    benchmark:test_avg(qsort,qsort_seq,[randlist(100)],10).

benchmark_sort_conc() ->
    benchmark:test_avg(qsort,qsort_concurrent,[randlist(10)],10).

benchmark_sort_both() ->
    List = randlist(100000),
    io:fwrite("Sequential:\n"),
    benchmark:test_avg(qsort,qsort_seq,[List],10),
    io:fwrite("Concurrent:\n"),
    benchmark:test_avg(qsort,qsort_concurrent,[List],10).
