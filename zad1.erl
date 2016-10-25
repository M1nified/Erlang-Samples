-module(zad1).
-export([
    randlist/1,
    qsort_seq/1,
    benchmark_sort_seq/0,
    qsort_concurrent_listener/0
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
                    PID_Parent ! {qsort_seq(List),Side};
                false ->
                    PID_left = spawn(fun qsort_concurrent_listener/0),
                    PID_right = spawn(fun qsort_concurrent_listener/0),
                    PID = self(),
                    PID_left ! {[X || X <- T, X < Pivot],PID,left},
                    PID_right ! {[X || X <- T, X >= Pivot],PID,right},
                    receive
                        {left,List} -> List
                    end,
                    receive
                        {right,List} -> List
                    end
            end
    end.
% sort(Parent,List) ->
%     if len(List)>2  
%         % split
%     else
%         % sort & send

benchmark_sort_seq()->
    benchmark:test_avg(zad1,qsort_seq,[randlist(100)],10).


