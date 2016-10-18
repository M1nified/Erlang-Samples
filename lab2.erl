-module(lab2).
-export([area/1,len/1,lmin/1]).
 
% area
area({rect,X,Y}) ->
    X*Y;
area({cir,X}) -> 3.14*X*X;
area({tri,A,H}) -> A*H/2;
area({trap,A,B,H}) -> (A+B)/2*H.

% list lenght
len([]) -> 0;
len(List) -> len(List,0).

len([],Len) -> Len;
len([_|Tail],Len) -> len(Tail,Len+1). 

% list min elem
lmin([]) -> ok;
lmin(List) -> lmin(List,ok).

lmin([H|Tail],ok) -> lmin(Tail,H);
lmin([],Min) -> Min;
lmin([H|Tail],Min) when H<Min -> lmin(Tail,H);
lmin([_|Tail],Min) -> lmin(Tail,Min).
