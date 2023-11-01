check_winner(Board,Width,Height,Y,Player) :-
    Y =< Height,
    X is 1,
    check_winner_row(Board,Width,Height,Y,X,Player),
    NY is Y+1,
    check_winner(Board,Width,Height,NY,Player),
    !.

check_winner(_,_,Height,Y,_) :- Y > Height.

check_winner_row(Board,Width,Height,Y,X,Player) :-
    X =< Width,
    \+check_winner_piece(Board,Width,Height,Y,X,Player),
    NX is X+1,
    check_winner_row(Board,Width,Height,Y,NX,Player),
    !.

check_winner_row(_,Width,_,_,X,_) :- X > Width.

check_winner_piece(Board,Width,Height,Y,X,Player) :-
    nth1(Y,Board,Row),
    nth1(X,Row,Value),
    Value is Player,

    XUP is X+1,
    XDOWN is X-1,
    YUP is Y+1,
    YDOWN is Y-1,

    (
    check_adjacent_pieces(Board,Width,Height,Y,XUP,Player);
    check_adjacent_pieces(Board,Width,Height,Y,XDOWN,Player);
    check_adjacent_pieces(Board,Width,Height,YUP,X,Player);
    check_adjacent_pieces(Board,Width,Height,YDOWN,X,Player);
    check_adjacent_pieces(Board,Width,Height,YUP,XUP,Player);
    check_adjacent_pieces(Board,Width,Height,YDOWN,XDOWN,Player);
    check_adjacent_pieces(Board,Width,Height,YUP,XDOWN,Player);
    check_adjacent_pieces(Board,Width,Height,YDOWN,XUP,Player)
    ),
    !.

check_winner_piece(_,_,_,_,_,_,1).

check_adjacent_pieces(Board,Width,Height,Y,X,Player) :-
    Y =< Height,
    Y >= 1,
    X =< Width,
    X >= 1,
    nth1(Y,Board,Row),
    nth1(X,Row,Value),
    Value is Player,
    !.


