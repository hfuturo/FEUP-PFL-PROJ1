
check_move(XP,YP,XM,YM,Distances,Bool) :- 
    YP is YM,
    nth1(2,Distances,Value),
    XM >= XP-Value,
    XM =< XP+Value,
    !,
    Bool is 1.

check_move(XP,YP,XM,YM,Distances,Bool) :- 
    XP is XM,
    nth1(1,Distances,Value),
    YM >= YP-Value,
    YM =< YP+Value,
    !,
    Bool is 1.

check_move(XP,YP,XM,YM,Distances,Bool) :- 
    XP is XM,
    nth1(1,Distances,Value),
    YM >= YP-Value,
    YM =< YP+Value,
    !,
    Bool is 1.

check_move(_,_,_,_,_,Bool) :- Bool is 0.

[1,2]
[2,3]