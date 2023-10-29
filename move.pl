check_move_single_step(XP,YP,XM,YM,Bool) :- 
    DiffX is XP - XM,
    abs_value(DiffX,AbsDiffX),
    DiffY is YP - YM,
    abs_value(DiffY,AbsDiffY),
    AbsDiffX =< 1,
    AbsDiffX >= -1,
    AbsDiffY =< 1,
    AbsDiffY >= -1,
    !,
    Bool is 1.
check_move_single_step(_,_,_,_,Bool) :- Bool is 0.

/*
    Verifica a se peça moveu a distancia horizontal correta
*/
check_move(XP,YP,XM,YM,Distances,Bool) :- 
    YP is YM,
    nth1(2,Distances,Value),
    XM >= XP-Value,
    XM =< XP+Value,
    !,
    Bool is 1.

/*
    Verifica se a peça moveu a distancia vertical correta
*/
check_move(XP,YP,XM,YM,Distances,Bool) :- 
    XP is XM,
    nth1(1,Distances,Value),
    YM >= YP-Value,
    YM =< YP+Value,
    !,
    Bool is 1.

/*
    Verifica se a peça moveu a distancia da diagonal NW-SE correta
*/
check_move(XP,YP,XM,YM,Distances,Bool) :- 
    check_oposite_diff(XP,YP,XM,YM),
    nth1(3,Distances,Value),
    (
        (YM >= YP-Value, XM =< XP+Value),
        (YM =< YP+Value, XM >= XP-Value)
    ),
    !,
    Bool is 1.

/*
    Verifica se a peça moveu a distancia da diagonal NE-SW correta
*/
check_move(XP,YP,XM,YM,Distances,Bool) :- 
    check_same_diff(XP,YP,XM,YM),
    nth1(4,Distances,Value),
    (
        (YM >= YP-Value, XM >= XP-Value),
        (YM =< YP+Value, XM =< XP+Value)
    ),
    !,
    Bool is 1.

check_move(_,_,_,_,_,Bool) :- Bool is 0.

abs_value(Number, AbsValue) :-
    Number =< 0,
    AbsValue is -Number.
abs_value(Number, AbsValue) :- AbsValue is Number.

check_same_diff(XP,YP,XM,YM) :-
    DiffX is XP-XM,
    DiffY is YP-YM,
    DiffX is DiffY.

check_oposite_diff(XP,YP,XM,YM) :-
    DiffX is XP-XM,
    DiffY is YP-YM,
    DiffX is -DiffY.
