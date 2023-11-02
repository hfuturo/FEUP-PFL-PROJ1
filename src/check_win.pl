:- consult(piece).
/*
    Verifica se o jogador ganhou
    check_winner(+Board,+Width,+Height,+Y,+Player)
*/
check_winner((Width,Height),Board,Y,Player) :-
    Y =< Height,
    X is 1,
    check_winner_row(Board,Width,Height,Y,X,Player),
    NY is Y+1,
    check_winner((Width,Height),Board,NY,Player),
    !.

check_winner((_,Height),_,Y,_) :- Y > Height.

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
    get_position_player(X,Y,(Width,Height),(Board,Player,_)),
    XUP is X+1,
    XDOWN is X-1,
    YUP is Y+1,
    YDOWN is Y-1,
    (
        get_position_player(XUP,Y,(Width,Height),(Board,Player,_));
        get_position_player(XDOWN,Y,(Width,Height),(Board,Player,_));
        get_position_player(X,YUP,(Width,Height),(Board,Player,_));
        get_position_player(X,YDOWN,(Width,Height),(Board,Player,_));
        get_position_player(XUP,YUP,(Width,Height),(Board,Player,_));
        get_position_player(XDOWN,YDOWN,(Width,Height),(Board,Player,_));
        get_position_player(XDOWN,YUP,(Width,Height),(Board,Player,_));
        get_position_player(XUP,YDOWN,(Width,Height),(Board,Player,_))
    ),
    !.


