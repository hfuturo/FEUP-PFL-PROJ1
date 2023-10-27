:- consult(move).

/*
    choose piece to move and remove it from its place
*/
choose_move(Turn,Height,Width,Board,XP,YP,XM,YM) :-
    %repeat,
    select_piece(Turn,Height,Width,Board,XP,YP),
    calculate_distances(XP,YP,Turn,Height,Width,Board,Distances),
    write(Distances),
    select_move(Height,Width,XM,YM),
    check_move(XP,YP,XM,YM,Width,Height,Board,Turn,Bool).
    %change_piece(0,Board,X,Y,NewBoard).

/*
    calcula todas as distancias em todas as direcoes que a peça consegue percorrer
    Distances vai retornar uma lista com as distancias nas seguintes direcoes [↑,↗,→,↘,↓,↙,←,↖]
*/
calculate_distances(X,Y,Turn,Height,Width,Board,Distances) :-
    row_distance(X,Y,Board,Width,Turn,DistancePos,DistanceNeg),
    append([DistancePos],[DistanceNeg],Distances).

/*
    calcula as distancias que a peça consegue percorrer numa linha horizontal
*/
row_distance(X,Y,Board,Width,Turn,DistancePos,DistanceNeg) :-
    nth1(Y,Board,Row),
    nth1(X,Row,XValue),
    row_distance_pos(X,Row,XValue,Width,Turn,DistancePos),
    row_distance_neg(X,Row,XValue,Turn,DistanceNeg),

/*
    calcula a distancia que a peça consegue percorrer para a direita
*/
row_distance_pos(Width,_,_,Width,_,0).  % chega ao fim da board
row_distance_pos(_,_,0,_,1,0).  % jogador 1 encontra 0
row_distance_pos(_,_,0,_,2,0).  % jogador 2 encontra 0
row_distance_pos(_,_,1,_,2,0).  % jogador 2 encontra 1
row_distance_pos(_,_,2,_,1,0).  % jogador 1 encontra 2
row_distance_pos(X,Row,XValue,Width,Turn,Distance) :-
    X =< Width,
    XValue is Turn,
    UpdatedX is X + 1,
    nth1(UpdatedX,Row,UpdatedXVal),
    row_distance_pos(UpdatedX,Row,UpdatedXVal,Width,Turn,UpdatedDistance),
    Distance is UpdatedDistance + 1.

/*
    calcula a distancia que a peça consegue percorrer para a esquerda
*/
row_distance_neg(1,_,_,_,0).  % chega ao inicio da board
row_distance_neg(_,_,0,1,0).  % jogador 1 encontra 0
row_distance_neg(_,_,0,2,0).  % jogador 2 encontra 0
row_distance_neg(_,_,1,2,0).  % jogador 2 encontra 1
row_distance_neg(_,_,2,1,0).  % jogador 1 encontra 2
row_distance_neg(X,Row,XValue,Turn,Distance) :-
    X >= 1,
    XValue is Turn,
    UpdatedX is X - 1,
    nth1(UpdatedX,Row,UpdatedXVal),
    row_distance_neg(UpdatedX,Row,UpdatedXVal,Turn,UpdatedDistance),
    Distance is UpdatedDistance + 1.

move(Turn,Height,Width,XP,YP,XM,YM,Board,NewBoard) :-
    change_piece(0,Board,XP,YP,TempBoard),
    change_piece(Turn,TempBoard,XM,YM,NewBoard).

/*
    select the move to make
*/
select_move(Height,Width,X,Y) :-
    repeat,
    write('\nSelect the coordinates to where you want to move.\n'),
    write('Column: '),
    read_column_piece(X,Width),
    write('Row: '),
    read_row_piece(Y,Height),
    !.

/*
    select the piece that the player wants to move
*/
select_piece(Turn,Height,Width,Board,X,Y) :-
    repeat,
    write('\nSelect the coordinates where the piece is.\n'),
    write('Column: '),
    read_column_piece(X,Width),
    write('Row: '),
    read_row_piece(Y,Height),
    get_position_piece(X,Y,Board,Piece),
    Turn is Piece,
    !.

/*
    remove piece selected
*/
change_piece(Value,Board,X,Y,NewBoard) :-
    nth1(Y,Board,Row),
    nth1(X,Row,_,TempRow),
    nth1(X,NewRow,Value,TempRow),
    nth1(Y,Board,_,TempBoard),
    nth1(Y,NewBoard,NewRow,TempBoard).
  
/*
    check if coordinates are valid according with the board' size
*/  
read_row_piece(Position,Coordinate) :-
    repeat,
    read_number(Position),
    Position>=1,
    Position=<Coordinate,
    !.

/*
    read column input of the piece
*/
read_column_piece(Position,Coordinate) :-
    repeat,
    read_char(Position),
    Position>=1,
    Position=<Coordinate,
    !.

/*
    get what element is in the position of the coordinates
*/
get_position_piece(X,Y,Board,Piece) :-
    nth1(Y,Board,Row),
    nth1(X,Row,Piece).

not_player(1,0).
not_player(1,2).
not_player(2,1).
not_player(2,0).