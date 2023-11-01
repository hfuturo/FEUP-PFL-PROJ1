:- consult(piece).
/*
    Verifica se o jogador ganhou
    check_winner(+Board,+Width,+Height,+Y,+Player)
*/
check_winner(Board,Width,Height,Y,Player) :-
    Y =< Height,
    X is 1,
    check_winner_row(Board,Width,Height,Y,X,Player),
    NY is Y+1,
    check_winner(Board,Width,Height,NY,Player),
    !.

check_winner(_,_,Height,Y,_) :- Y > Height.

/*
    Verifica se o jogador tem uma linha completa com peças isoladas
    check_winner_row(+Board,+Width,+Height,+Y,+X,+Player)
*/
check_winner_row(Board,Width,Height,Y,X,Player) :-
    X =< Width,
    \+check_winner_piece(Board,Width,Height,Y,X,Player),
    NX is X+1,
    check_winner_row(Board,Width,Height,Y,NX,Player),
    !.

check_winner_row(_,Width,_,_,X,_) :- X > Width.

/*
    Verifica se a peça está isolada
    check_winner_piece(+Board,+Width,+Height,+Y,+X,+Player)
*/
check_winner_piece(Board,Width,Height,Y,X,Player) :-
    get_position_player(X,Y,Board,Width,Height,Player),
    XUP is X+1,
    XDOWN is X-1,
    YUP is Y+1,
    YDOWN is Y-1,
    (
        get_position_player(XUP,Y,Board,Width,Height,Player);
        get_position_player(XDOWN,Y,Board,Width,Height,Player);
        get_position_player(X,YUP,Board,Width,Height,Player);
        get_position_player(X,YDOWN,Board,Width,Height,Player);
        get_position_player(XUP,YUP,Board,Width,Height,Player);
        get_position_player(XDOWN,YDOWN,Board,Width,Height,Player);
        get_position_player(XDOWN,YUP,Board,Width,Height,Player);
        get_position_player(XUP,YDOWN,Board,Width,Height,Player)
    ),
    !.


