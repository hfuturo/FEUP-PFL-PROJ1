/*
    Verifica a se peça moveu a distancia horizontal correta
*/
check_move(XP,YP,XM,YM,Distances,Bool) :- 
    YP is YM,
    nth1(2,Distances,Value),
    (XM is XP-Value; XM is XP+Value),
    !,
    Bool is 1.

/*
    Verifica se a peça moveu a distancia vertical correta
*/
check_move(XP,YP,XM,YM,Distances,Bool) :- 
    XP is XM,
    nth1(1,Distances,Value),
    (YM is YP-Value; YM is YP+Value),
    !,
    Bool is 1.

/*
    Verifica se a peça moveu a distancia da diagonal NW-SE correta
*/
check_move(XP,YP,XM,YM,Distances,Bool) :- 
    check_oposite_diff(XP,YP,XM,YM),
    nth1(3,Distances,Value),
    (
        (YM is YP-Value, XM is XP+Value);
        (YM is YP+Value, XM is XP-Value)
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
        (YM is YP-Value, XM is XP-Value);
        (YM is YP+Value, XM is XP+Value)
    ),
    !,
    Bool is 1.

check_move(_,_,_,_,_,Bool) :- Bool is 0.

/*
    Calcula o valor absoluto de um número
*/
abs_value(Number, AbsValue) :-
    Number =< 0,
    AbsValue is -Number.
abs_value(Number, AbsValue) :- AbsValue is Number.

/*
    Verificar se a diferença é a mesma
*/
check_same_diff(XP,YP,XM,YM) :-
    DiffX is XP-XM,
    DiffY is YP-YM,
    DiffX is DiffY.

/*
    Verificar se a diferença é diferente
*/
check_oposite_diff(XP,YP,XM,YM) :-
    DiffX is XP-XM,
    DiffY is YP-YM,
    DiffX is -DiffY.
