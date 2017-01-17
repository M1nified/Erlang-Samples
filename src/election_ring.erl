% Leader election algorithm
-module(election_ring).
-export([
    init_ring/1
]).

-record(state, {
    number :: integer(),
    pids :: list(),
    coordinator :: pid(),
    loop_ref :: reference()
}).

init_ring(Size) when Size>1->
    Pids = [ spawn(fun() -> init(Number) end) || Number <- lists:seq(1,Size)],
    lists:foreach(fun(Pid) -> Pid ! {starting_pids, Pids} end, Pids),
    Pids.


init(Number) ->
    io:fwrite("[~2.. B] [~p] Initialized\n",[Number, self()]),
    receive
        {starting_pids, Pids} ->
            loop(#state{
                pids = Pids,
                number = Number
            })
    end,
    ok.

loop(State) ->
    receive
        Any -> 
            % io:fwrite("[~2.. B] [~p] Received: ~p\n",[State#state.number,self(),Any]),
            recv(State, Any)
    end.

recv(State, {died, Pid}) ->
    Ref = make_ref(),
    NewState = State#state{
        loop_ref=Ref,
        pids=State#state.pids -- [Pid]
    },
    io:fwrite("[~2.. B] [~p] died, NewState:\n~p\n",[State#state.number,self(),NewState]),
    sendToNext(NewState, {election, Ref, [self()], {dead, Pid}}),
    loop(NewState);
recv(State, {election, Ref, Participants, {dead, DeadPid}}) ->
    io:fwrite("[~2.. B] [~p] election \n",[State#state.number,self()]),
    case State#state.loop_ref of
        Ref ->
            Coordinator = lists:max(Participants),
            RefCoord = make_ref(),
            sendToNext(State, {coordinator, RefCoord, Coordinator}),
            loop(State#state{coordinator=Coordinator, loop_ref=RefCoord});
        _ ->
            NewState = State#state{pids = State#state.pids -- [DeadPid]},
            ParticipantsAndMe = Participants ++ [self()],
            sendToNext(NewState, {election, Ref, ParticipantsAndMe, {dead, DeadPid}}),
            loop(NewState)
    end;
recv(State, {coordinator, Ref, Coordinator}) when Ref/=State#state.loop_ref ->
    io:fwrite("[~2.. B] [~p] coordinator (1) <- ~p\n",[State#state.number,self(),Coordinator]),
    sendToNext(State, {coordinator, Ref, Coordinator}),
    loop(State#state{coordinator=Coordinator});
recv(State, {coordinator, _Ref, _Coordinator}) ->
    io:fwrite("[~2.. B] [~p] coordinator (2) \n",[State#state.number,self()]),
    loop(State);
recv(State, Other) ->
    io:fwrite("[~2.. B] [~p] recv Other: ~p\n",[State#state.number,self(),Other]),
    loop(State).

sendToNext(State, Message) ->
    case nextAfter(State#state.pids, self()) of
        undefined ->
            fst(State#state.pids) ! Message;
        Element ->
            Element ! Message
    end,
    ok.


% Helpers

fst([]) ->
    undefined;
fst([H]) ->
    H;
fst([H|_]) ->
    H.
nextAfter([Current|List],Element) ->
    case Current of
        Element ->
            fst(List);
        _ ->
            nextAfter(List,Element)
    end.
