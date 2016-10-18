-module(lab2).
-export([area/1,len/1,amin/1]).
 
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
amin([]) -> ok;
amin(List) -> amin(List,ok).

amin([H|Tail],ok) -> amin(Tail,H);
amin([],Min) -> Min;
amin([H|Tail],Min) when H<Min -> amin(Tail,H);
amin([_|Tail],Min) -> amin(Tail,Min).
