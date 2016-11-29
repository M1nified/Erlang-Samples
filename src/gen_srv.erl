-module(gen_srv).
-export([
    init/1
]).

-define(STATE_FILE,"gen_srv_state").

-record(loopobj,{
    state :: any(),
    jobmodule :: module()
}).
-type loopobj() :: #loopobj{}.

-spec init(atom()) -> pid().
init(JobModule) ->
    RecentState = state_load(),
    io:format("RecentState = ~p\n",[RecentState]),
    case RecentState of
        {error, _} ->
            spawn(fun() -> loop(#loopobj{jobmodule=JobModule}) end);
        {ok,_} ->
            spawn(fun() -> loop(#loopobj{jobmodule=JobModule, state=RecentState}) end)
    end.


-spec loop(loopobj()) -> any().
loop(Loop) ->
    receive
        {debug,Any} ->
            debug(Loop,Any);
        Any ->
            recv(Loop,Any)            
    end.

-spec recv(loopobj(),any()) -> any().
recv(Loop,{call,From,Ref,Data}) when is_pid(From) and is_reference(Ref) ->
    {Result,NewState} = just_do_it(Loop,Data),
    spawn(fun() -> From ! {Ref,Result} end),
    loop(Loop#loopobj{state=NewState});

recv(Loop,{cast,From,Ref,Data}) when is_pid(From) and is_reference(Ref) ->
    {_,NewState} = just_do_it(Loop,Data),
    loop(Loop#loopobj{state=NewState});

recv(Loop,{update,From,Ref,Module}) when is_pid(From) and is_reference(Ref) and is_atom(Module) ->
    loop(Loop#loopobj{jobmodule=Module});

recv(Loop,{save, From, Ref}) when is_pid(From) and is_reference(Ref) ->
    state_save(Loop),
    loop(Loop);

recv(Loop,_) ->
    io:fwrite("Unknown command!\n"),
    loop(Loop).

just_do_it(Loop,Data) ->
    JobModule = Loop#loopobj.jobmodule,
    Result = JobModule:action(Data,Loop#loopobj.state),
    NewState = JobModule:state(Loop#loopobj.state,Result),
    {Result,NewState}.

% Actions

state_save(Loop) ->
    file:write_file(?STATE_FILE,term_to_binary(Loop#loopobj.state)),
    ok.

state_load() ->
    case file:read_file(?STATE_FILE) of
        {ok, Binary} ->
            {ok, binary_to_term(Binary)};
        {error, Reason} ->
            {error, Reason}
    end.

% Debug

debug(Loop,print_state) ->
    io:format("Current state is: ~p\n",[Loop#loopobj.state]),
    loop(Loop).