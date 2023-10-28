:- consult(move).

/*
    choose piece to move and remove it from its place
*/
choose_move(Turn,Height,Width,Board,XP,YP,XM,YM) :-
    %repeat,
    select_piece(Turn,Height,Width,Board,XP,YP),
    calculate_distances(XP,YP,Turn,Height,Width,Board,Distances),
    select_move(Height,Width,XM,YM),
    check_move(XP,YP,XM,YM,Width,Height,Board,Turn,Bool).
    %change_piece(0,Board,X,Y,NewBoard).

/*
    calcula todas as distancias em todas as direcoes que a peça consegue percorrer
    Distances vai retornar uma lista com as distancias nas seguintes direcoes [vertical,horizontal,diagonal]
*/
calculate_distances(X,Y,Turn,Height,Width,Board,Distances) :-
    row_distance(X,Y,Board,Width,Turn,RowDistance),
    column_distance(X,Y,Board,Height,Turn,ColumnDistance),
    append([ColumnDistance],[RowDistance],Distances),
    write(Distances).

/*
    calcula a distancia que a peça pode percorrer verticalemente
*/
column_distance(X,Y,Board,Height,Turn,Distance) :-
    nth1(Y,Board,Row),
    nth1(X,Row,XValue),
    Times is 0,
    column_distance_up(X,Y,XValue,Board,Turn,Times,ColumnUp),
    column_distance_down(X,Y,XValue,Height,Board,Turn,Times,ColumnDown),
    Distance is ColumnUp + ColumnDown - 1.

/*
    calcula o numero de peças da mesma equipa seguidas que estão em cima da peça
*/
column_distance_up(_,1,_,_,_,0,1) :- !.  % peça encontra-se encostada a board
column_distance_up(_,1,1,_,1,_,1) :- !.  % jogador 1 encontra 1 no fim da board
column_distance_up(_,1,2,_,2,_,1) :- !.  % jogador 2 encontra 2 no fim da board
column_distance_up(_,1,_,_,_,_,0).       % jogador 1/2 encontra 0,2/0,1 no fim da board
column_distance_up(_,_,0,_,1,_,0).       % jogador 1 encontra 0
column_distance_up(_,_,2,_,1,_,0).       % jogador 1 encontra 2
column_distance_up(_,_,0,_,2,_,0).       % jogador 2 encontra 0
column_distance_up(_,_,1,_,2,_,0).       % jogador 2 encontra 1
column_distance_up(X,Y,XValue,Board,Turn,Times,Distance) :-
    Y >= 1,
    XValue is Turn,
    UpdatedY is Y - 1,
    UpdatedTimes is Times + 1,
    nth1(UpdatedY,Board,Row),
    nth1(X,Row,UpdatedXVal),
    column_distance_up(X,UpdatedY,UpdatedXVal,Board,Turn,UpdatedTimes,UpdatedDistance),
    Distance is UpdatedDistance + 1.

/*
    calcula o numero de peças da mesma equipa seguidas que estão em baixo da peça
*/
column_distance_down(_,Height,_,Height,_,_,0,1) :- !.   % peça encontra-se encostada a board.
column_distance_down(_,Height,1,Height,_,1,_,1) :- !.   % jogador 1 encontra 1 no fim da board.
column_distance_down(_,Height,2,Height,_,2,_,1) :- !.   % jogador 2 encontra 2 no fim da board.
column_distance_down(_,Height,_,Height,_,_,_,0).        % jogador 1/2 encontra 0,2/0,1 no fim da board
column_distance_down(_,_,0,_,_,1,_,0).                  % jogador 1 encontra 0
column_distance_down(_,_,2,_,_,1,_,0).                  % jogador 1 encontra 2
column_distance_down(_,_,0,_,_,2,_,0).                  % jogador 2 encontra 0
column_distance_down(_,_,1,_,_,2,_,0).                  % jogador 2 encontra 1
column_distance_down(X,Y,XValue,Height,Board,Turn,Times,Distance) :-
    Y =< Height,
    XValue is Turn,
    UpdatedY is Y + 1,
    UpdatedTimes is Times + 1,
    nth1(UpdatedY,Board,Row),
    nth1(X,Row,UpdatedXVal),
    column_distance_down(X,UpdatedY,UpdatedXVal,Height,Board,Turn,UpdatedTimes,UpdatedDistance),
    Distance is UpdatedDistance + 1.

/*
    calcula as distancias que a peça consegue percorrer numa linha horizontal
*/
row_distance(X,Y,Board,Width,Turn,Distance) :-
    nth1(Y,Board,Row),
    nth1(X,Row,XValue),
    Times is 0,
    row_distance_right(X,Row,XValue,Width,Turn,Times,DistanceRight),
    row_distance_left(X,Row,XValue,Turn,Times,DistanceLeft),
    Distance is DistanceRight + DistanceLeft - 1.

/*
    calcula a distancia que a peça consegue percorrer para a direita
*/
row_distance_right(Width,_,_,Width,_,0,1) :- !.   % peça encontra-se encostada a board
row_distance_right(Width,_,1,Width,1,_,1) :- !.   % jogador 1 encontra 1 no fim da board
row_distance_right(Width,_,2,Width,2,_,1) :- !.   % jogador 2 encontra 2 no fim da board
row_distance_right(Width,_,_,Width,_,_,0).        % jogador 1/2 encontra 0,2/0,1 no fim da board
row_distance_right(_,_,0,_,1,_,0).                % jogador 1 encontra 0
row_distance_right(_,_,0,_,2,_,0).                % jogador 2 encontra 0
row_distance_right(_,_,1,_,2,_,0).                % jogador 2 encontra 1
row_distance_right(_,_,2,_,1,_,0).                % jogador 1 encontra 2
row_distance_right(X,Row,XValue,Width,Turn,Times,Distance) :-
    X =< Width,
    XValue is Turn,
    UpdatedX is X + 1,
    UpdatedTimes is Times + 1,
    nth1(UpdatedX,Row,UpdatedXVal),
    row_distance_right(UpdatedX,Row,UpdatedXVal,Width,Turn,UpdatedTimes,UpdatedDistance),
    Distance is UpdatedDistance + 1.

/*
    calcula a distancia que a peça consegue percorrer para a esquerda
*/
row_distance_left(1,_,_,_,0,1) :- !.     % peça encontra-se encostada a board
row_distance_left(1,_,1,1,_,1) :- !.     % jogador 1 encontra 1 no fim da board
row_distance_left(1,_,2,2,_,1) :- !.     % jogador 2 encontra 2 no fim da board
row_distance_left(1,_,_,_,_,0).          % jogador 1/2 encontra 0,2/0,1 no fim da board
row_distance_left(_,_,0,1,_,0).          % jogador 1 encontra 0
row_distance_left(_,_,0,2,_,0).          % jogador 2 encontra 0
row_distance_left(_,_,1,2,_,0).          % jogador 2 encontra 1
row_distance_left(_,_,2,1,_,0).          % jogador 1 encontra 2
row_distance_left(X,Row,XValue,Turn,Times,Distance) :-
    X >= 1,
    XValue is Turn,
    UpdatedX is X - 1,
    UpdatedTimes is Times + 1,
    nth1(UpdatedX,Row,UpdatedXVal),
    row_distance_left(UpdatedX,Row,UpdatedXVal,Turn,UpdatedTimes,UpdatedDistance),
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