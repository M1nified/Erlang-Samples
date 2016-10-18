% spwan, recieve, message DEMO
-module(proc).
-export([
    mkrec/0,
    sendMsg/2
]).

listen() -> 
    receive 
        Any -> io:fwrite("sth\n"),
        listen()
    after 
        2000 -> io:fwrite("daly\n")
    end.
    
mkrec()-> 
    spawn(fun listen/0).

sendMsg(Where,Msg) ->
    Where ! Msg.