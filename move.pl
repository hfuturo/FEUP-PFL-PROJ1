
check_move(XP,YP,XM,YM,Width,_,Board,Turn,Bool) :- 
    check_row(XP,YP,XM,YM,Board,Width,Turn,RowBool),
    (RowBool = 1 -> Bool = 1 ; Bool = 0).
    %format('~w \n',Bool).

/*
    check how long is the horizontal line and if move is possible
*/
check_row(XP,YP,XM,YM,Board,Width,Turn,RowBool) :-
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
