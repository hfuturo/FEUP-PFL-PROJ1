check_winner(Board,Width,Height,Y,Player,BoardWinner) :-
    Y =< Height,
    X is 1,
    check_winner_row(Board,Width,Height,Y,X,Player,Winner),
    Winner is 1,
    NY is Y+1,
    check_winner(Board,Width,Height,NY,Player,BoardWinner),
    !.

check_winner(_,_,Height,Y,_,1) :- Y > Height.
check_winner(_,_,_,_,_,BoardWinner) :- BoardWinner is 0.

check_winner_row(Board,Width,Height,Y,X,Player,RowWinner) :-
    X =< Width,
    check_winner_piece(Board,Width,Height,Y,X,Player,Winner),
    Winner is 1,
    NX is X+1,
    check_winner_row(Board,Width,Height,Y,NX,Player,RowWinner),
    !.

check_winner_row(_,Width,_,_,X,_,1) :- X > Width.
check_winner_row(_,_,_,_,_,_,RowWinner) :- RowWinner is 0.

check_winner_piece(Board,Width,Height,Y,X,Player,PieceWinner) :-
    nth1(Y,Board,Row),
    nth1(X,Row,Value),
    Value is Player,
    XUP is X+1,
    XDOWN is X-1,
    YUP is Y+1,
    YDOWN is Y-1,

    check_adjacent_pieces(Board,Width,Height,Y,XUP,Player,Winner1),
    check_adjacent_pieces(Board,Width,Height,Y,XDOWN,Player,Winner2),
    check_adjacent_pieces(Board,Width,Height,YUP,X,Player,Winner3),
    check_adjacent_pieces(Board,Width,Height,YDOWN,X,Player,Winner4),
    check_adjacent_pieces(Board,Width,Height,YUP,XUP,Player,Winner5),
    check_adjacent_pieces(Board,Width,Height,YDOWN,XDOWN,Player,Winner6),
    check_adjacent_pieces(Board,Width,Height,YUP,XDOWN,Player,Winner7),
    check_adjacent_pieces(Board,Width,Height,YDOWN,XUP,Player,Winner8),

    (
        Winner1 is 0;
        Winner2 is 0;
        Winner3 is 0;
        Winner4 is 0;
        Winner5 is 0;
        Winner6 is 0;
        Winner7 is 0;
        Winner8 is 0
    ),
    PieceWinner is 0,
    !.

check_winner_piece(_,_,_,_,_,_,1).

check_adjacent_pieces(Board,Width,Height,Y,X,Player,Winner) :-
    Y =< Height,
    Y >= 1,
    X =< Width,
    X >= 1,
    nth1(Y,Board,Row),
    nth1(X,Row,Value),
    Value is Player,
    Winner is 0,
    !.

check_adjacent_pieces(_,_,_,_,_,_,1) .


