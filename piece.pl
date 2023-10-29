:- consult(check_move).
:- consult(line_distance).

/*
    escolher movimento na primeira jogada
*/
choose_move(Turn,Height,Width,Board,XP,YP,XM,YM,0) :-
    repeat,
    write('\n----------------------------------------------------|'),
    write('\n| First move of the game, it must be a Single Step. |'),
    write('\n----------------------------------------------------|'),
    select_piece(Turn,Height,Width,Board,XP,YP),
    select_move(Turn,Height,Width,Board,XM,YM,XP,YP),
    check_move_single_step(XP,YP,XM,YM,Bool),
    Bool is 1,
    !.

/*
    escolher movimento
*/
choose_move(Turn,Height,Width,Board,XP,YP,XM,YM,_) :-
    repeat,
    select_piece(Turn,Height,Width,Board,XP,YP),
    calculate_distances(XP,YP,Turn,Height,Width,Board,Distances),
    select_move(Turn,Height,Width,Board,XM,YM,XP,YP),
    check_move(XP,YP,XM,YM,Distances,Bool),
    Bool is 1,
    !.

/*
    atualzizar o tabuleiro de acordo com a movimentação
*/
move(Turn,XP,YP,XM,YM,Board,NewBoard) :-
    change_piece(0,Board,XP,YP,TempBoard),
    change_piece(Turn,TempBoard,XM,YM,NewBoard).

/*
    escolher o movimento a fazer
*/
select_move(Turn,Height,Width,Board,X,Y,XP,YP) :-
    repeat,
    write('\nSelect the coordinates to where you want to move.\n'),
    write('Column: '),
    read_column_piece(X,Width),
    write('Row: '),
    read_row_piece(Y,Height),
    get_position_piece(X,Y,Board,Piece),
    Turn \== Piece,
    (XP \== X; YP \== Y),
    !.

/*
    escolher a peça a mover
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
    alterar peça numa determinada posição do tabuleiro
*/
change_piece(Value,Board,X,Y,NewBoard) :-
    nth1(Y,Board,Row),
    nth1(X,Row,_,TempRow),
    nth1(X,NewRow,Value,TempRow),
    nth1(Y,Board,_,TempBoard),
    nth1(Y,NewBoard,NewRow,TempBoard).
  
/*
    ler coordenada Y da peça
*/  
read_row_piece(Position,Coordinate) :-
    repeat,
    read_number(Position),
    Position>=1,
    Position=<Coordinate,
    !.

/*
    ler coordenada X da peça
*/
read_column_piece(Position,Coordinate) :-
    repeat,
    read_char(Position),
    Position>=1,
    Position=<Coordinate,
    !.

/*
    ver qual a peça que está numa determinada posição do tabuleiro
*/
get_position_piece(X,Y,Board,Piece) :-
    nth1(Y,Board,Row),
    nth1(X,Row,Piece).