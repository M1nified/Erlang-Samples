-module(gen_srv).
-export([
    init/1
]).

-record(loopobj,{
    state :: any(),
    jobmodule :: module()
}).
-type loopobj() :: #loopobj{}.

-spec init(atom()) -> pid().
init(JobModule) ->
    spawn(fun() -> loop(#loopobj{jobmodule=JobModule}) end).

-spec loop(loopobj()) -> any().
loop(Loop) ->
    receive
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

recv(Loop,_) ->
    io:fwrite("Unknown command!\n"),
    loop(Loop).

just_do_it(Loop,Data) ->
    JobModule = Loop#loopobj.jobmodule,
    Result = JobModule:action(Data,Loop#loopobj.state),
    NewState = JobModule:state(Loop#loopobj.state,Result),
    {Result,NewState}.