-module(lab2).
-export([
    area/1,
    len/1,
    amin/1,
    amax/1,
    tmin_max/1,
    lmin_max/1,
    areas/1,
    cd/1
]).
 
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
amin([H|Tail]) -> amin(Tail,H).

amin([],Min) -> Min;
amin([H|Tail],Min) when H<Min -> amin(Tail,H);
amin([_|Tail],Min) -> amin(Tail,Min).

% list max elem
amax([]) -> ok;
amax([H|Tail]) -> amax(Tail,H).

amax([],Min) -> Min;
amax([H|Tail],Min) when H>Min -> amax(Tail,H);
amax([_|Tail],Min) -> amax(Tail,Min).

% list min max
tmin_max([]) -> ok;
tmin_max(List) -> {amin(List),amax(List)}.

% list min max as list
lmin_max([]) -> [];
lmin_max(List) -> [amin(List),amax(List)].

% list of areas
areas([]) -> [];
areas(List) -> lists:map(fun(K)->area(K) end,List).

% count down
cd(1) -> [1];
cd(Num) -> [Num] ++ cd(Num-1).