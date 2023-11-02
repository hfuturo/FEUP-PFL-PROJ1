/*
    Verifica se o jogador ganhou
    check_winner(+Board,+Y,+Player)
*/
check_winner(Board,Y,Player) :-
    board_size(Height,_,(Board,_,_)),
    Y =< Height,
    X is 1,
    check_winner_row(Board,Y,X,Player),
    NY is Y+1,
    check_winner(Board,NY,Player),
    !.

check_winner(Board,Y,_) :- board_size(Height,_,(Board,_,_)), Y > Height.

/*
    Verifica se o jogador tem uma linha completa com peças isoladas
    check_winner_row(+Board,+Y,+X,+Player)
*/
check_winner_row(Board,Y,X,Player) :-
    board_size(_,Width,(Board,_,_)),
    X =< Width,
    \+check_winner_piece(Board,Y,X,Player),
    NX is X+1,
    check_winner_row(Board,Y,NX,Player),
    !.

check_winner_row(Board,_,X,_) :- board_size(_,Width,(Board,_,_)), X > Width.

/*
    Verifica se a peça está isolada
    check_winner_piece(+Board,+Y,+X,+Player)
*/
check_winner_piece(Board,Y,X,Player) :-
    get_position_player(X,Y,(Board,Player,_)),
    XUP is X+1,
    XDOWN is X-1,
    YUP is Y+1,
    YDOWN is Y-1,
    (
        get_position_player(XUP,Y,(Board,Player,_));
        get_position_player(XDOWN,Y,(Board,Player,_));
        get_position_player(X,YUP,(Board,Player,_));
        get_position_player(X,YDOWN,(Board,Player,_));
        get_position_player(XUP,YUP,(Board,Player,_));
        get_position_player(XDOWN,YDOWN,(Board,Player,_));
        get_position_player(XDOWN,YUP,(Board,Player,_));
        get_position_player(XUP,YDOWN,(Board,Player,_))
    ),
    !.


