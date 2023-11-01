
/*
    Verifica se a peça moveu uma distancia possivel
    check_move(+XP,+YP,+XM,+YM,+Distances) :- 
*/

/* horizontal */
check_move(XP,YP,XM,YM,Distances) :- 
    YP is YM,
    nth1(2,Distances,Value),
    (XM is XP-Value; XM is XP+Value),
    !.

/* vertical */
check_move(XP,YP,XM,YM,Distances) :- 
    XP is XM,
    nth1(1,Distances,Value),
    (YM is YP-Value; YM is YP+Value),
    !.

/* diagonal NW-SE */
check_move(XP,YP,XM,YM,Distances) :- 
    check_oposite_diff(XP,YP,XM,YM),
    nth1(3,Distances,Value),
    (
        (YM is YP-Value, XM is XP+Value);
        (YM is YP+Value, XM is XP-Value)
    ),
    !.

/* diagonal NE-SW */
check_move(XP,YP,XM,YM,Distances) :- 
    check_same_diff(XP,YP,XM,YM),
    nth1(4,Distances,Value),
    (
        (YM is YP-Value, XM is XP-Value);
        (YM is YP+Value, XM is XP+Value)
    ),
    !.

/*
    Calcula o valor absoluto de um número
    abs_value(+Number,-AbsValue)
*/
abs_value(Number, AbsValue) :-
    Number =< 0,
    AbsValue is -Number.
abs_value(Number, AbsValue) :- AbsValue is Number.

/*
    Verifica se as diferenças entre XP-XM e YP-YM são as mesmas
    check_same_diff(+XP,+YP,+XM,+YM)
*/
check_same_diff(XP,YP,XM,YM) :-
    DiffX is XP-XM,
    DiffY is YP-YM,
    DiffX is DiffY.

/*
    Verifica se as diferenças entre XP-XM e YP-YM são opostas
    check_oposite_diff(+XP,+YP,+XM,+YM)
*/
check_oposite_diff(XP,YP,XM,YM) :-
    DiffX is XP-XM,
    DiffY is YP-YM,
    DiffX is -DiffY.
