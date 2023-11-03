/*
    Lê a coordenada Y
    read_row_piece(-Position,+Coordinate)
*/  
read_row_piece(Position,Coordinate) :-
    repeat,
    read_number(Position),
    Position>=1,
    Position=<Coordinate,
    !.

/*
    Lê a coordenada X
    read_column_piece(-Position,+Coordinate)
*/
read_column_piece(Position,Coordinate) :-
    repeat,
    read_char(Position),
    Position>=1,
    Position=<Coordinate,
    !.

/*
    Atualiza o tabuleiro de acordo com a movimentação
    move(+GameState,+Move,-NewGameState)
*/
move((Board,Turn,TotalMoves),(XP,YP,XM,YM),(NewBoard,Turn,NewTotalMoves)) :-
    change_piece(0,Board,XP,YP,TempBoard),
    change_piece(Turn,TempBoard,XM,YM,NewBoard),
    NewTotalMoves is TotalMoves+1.

/*
    Altera a peça numa determinada posição do tabuleiro
    change_piece(+Value,+Board,+X,+Y,-NewBoard)
*/
change_piece(Value,Board,X,Y,NewBoard) :-
    nth1(Y,Board,Row),
    nth1(X,Row,_,TempRow),
    nth1(X,NewRow,Value,TempRow),
    nth1(Y,Board,_,TempBoard),
    nth1(Y,NewBoard,NewRow,TempBoard).

/*
    Vê qual a peça que está numa determinada posição do tabuleiro
    get_position_piece(+X,+Y,+Board,-Piece) :-
*/
get_position_piece(X,Y,Board,Piece) :-
    nth1(Y,Board,Row),
    nth1(X,Row,Piece).

/*
    Vê se a peça é o do jogador
    get_position_player(+X,+Y,+GameState)
*/
get_position_player(X,Y,(Board,Player,_)) :-
    check_inside_board(X,Y,(Board,_,_)),
    get_position_piece(X,Y,Board,Piece),
    Piece is Player.

/*
    Verifica se a peça se encontra dentro da board.
    check_inside_board(+X,+Y,+GameState)
*/
check_inside_board(X,Y,GameState) :-
    board_size(Height,Width,GameState),
    Y =< Height,
    Y >= 1,
    X =< Width,
    X >= 1.

/*
    Verifica que a ultima movimentação foi do tipo adjacente
    no_jump(+XP,+YP,+XM,+YM)
*/
no_jump(XP,YP,XM,YM) :-
    (
        (XP is XM+1, YP is YM);
        (XP is XM-1, YP is YM);
        (XP is XM, YP is YM+1);
        (XP is XM, YP is YM-1);

        (XP is XM+1, YP is YM+1);
        (XP is XM+1, YP is YM-1);
        (XP is XM-1, YP is YM+1);
        (XP is XM-1, YP is YM-1)
    ).
