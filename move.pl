
check_move(XP,YP,XM,YM,Width,_,Board,Turn,Bool) :- 
    YP is YM,
    nth1(YP,Board,Row),
    check_row(XP,XM,Row,Width,Turn,RowBool),
    RowBool is 1,
    !,
    Bool is RowBool.

check_move(XP,YP,XM,YM,Width,_,Board,Turn,Bool) :- 
    XP is XM,
    !,
    get_column(Board,XP,Column),
    check_column(YP,YM,Column,Width,Turn,ColumnBool),
    Bool is ColumnBool.

check_move(XP,YP,XM,YM,Width,_,Board,Turn,Bool) :- Bool is 0.

check_row(XP,XM,_,_,_,RowBool) :- XM is XP+1,!,RowBool is 1.
check_row(XP,XM,_,_,_,RowBool) :- XM is XP-1,!,RowBool is 1.

/*
    jump in horizontal line
*/
check_row(XP,XM,Row,Width,Turn,RowBool) :-
    Number is 0,
    check_row_positive_aux(XP,Width,Number,Row,Turn,RightNumber),
    check_row_negative_aux(XP,Number,Row,Turn,LeftNumber),
    XM =< XP+RightNumber+RightNumber+LeftNumber,
    XM >= XP-LeftNumber-RightNumber-LeftNumber,
    !,
    RowBool is 1.

/*
    impossible move in horizontal line
*/
check_row(XP,XM,Row,Width,Turn,RowBool) :- RowBool is 0.

check_column(YP,YM,Column,Width,Turn,ColumnBool) :- YM is YP+1, !, ColumnBool is 1.
check_column(YP,YM,Column,Width,Turn,ColumnBool) :- YM is YP-1, !, ColumnBool is 1.


/*
    check how long is the horizontal line on the right side of the piece
*/
check_row_positive_aux(Width,Width,Number,_,_,FinalNumber) :-
FinalNumber is Number-1.
check_row_positive_aux(XP,Width,Number,Row,Turn,FinalNumber) :-
    nth1(XP,Row,Value),
    not_player(Value,Turn),
    !,
    FinalNumber is Number.

check_row_positive_aux(XP,Width,Number,Row,Turn,FinalNumber) :-
    NewNumber is Number+1,
    NewXP is XP+1,
    check_row_positive_aux(NewXP,Width,NewNumber,Row,Turn,FinalNumber).

/*
    check how long is the horizontal line on the left side of the piece
*/
check_row_negative_aux(0,Number,_,_,FinalNumber) :-
    FinalNumber is Number-1.
check_row_negative_aux(XP,Number,Row,Turn,FinalNumber) :-
    nth1(XP,Row,Value),
    not_player(Value,Turn),
    !,
    FinalNumber is Number.

check_row_negative_aux(XP,Number,Row,Turn,FinalNumber) :-
    NewNumber is Number+1,
    NewXP is XP-1, 
    check_row_positive_aux(NewXP,Width,NewNumber,Row,Turn,FinalNumber).

/*
    check how long is the horizontal line and if move is possible
*/
check_column(XP,YP,XM,YM,Board,Width,Turn,RowBool) :-
    YP is YM,
    nth1(YP,Board,Row),
    Number is 0,
    check_row_positive_aux(XP,Width,Number,Row,Turn,RightNumber),
    check_row_negative_aux(XP,Number,Row,Turn,LeftNumber),
    Diff is abs(XP-XM),
    MaxJump is LeftNumber+RightNumber,
    (
        Diff is 1 -> RowBool is 1;
        XM =< XP+RightNumber+MaxJump, XM >= XP-LeftNumber-MaxJump -> RowBool is 1;
        RowBool is 0
    ).



get_column([], _, []).

get_column([H|T], X, [Elem|Column]) :-
    nth1(X, H, Elem),
    get_column(T, X, Column).
