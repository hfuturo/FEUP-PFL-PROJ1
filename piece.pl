
choose_move(Turn,Height,Width,Board,NewBoard) :-
    select_piece(Turn,Height,Wide,Board,X,Y),
    change_piece(0,Board,X,Y,NewBoard).

move(Turn,Height,Wide,Board,NewBoard) :-
    select_move(Height,Wide,X,Y),
    change_piece(Turn,Board,X,Y,NewBoard).

/*
    select the move to make
*/
select_move(Height,Wide,X,Y) :-
    repeat,
    write('\nSelect the coordinates to where you want to move.\n'),
    write('Write the row of the new position.'),
    read_position_piece(X,Wide),
    write('Write the column of the new position.'),
    read_position_piece(Y,Height),
    !.

/*
    select the piece that the player wants to move
*/
select_piece(Turn,Height,Wide,Board,X,Y) :-
    repeat,
    write('\nSelect the coordinates where the piece is.\n'),
    write('Write the row of the piece.'),
    read_position_piece(X,Wide),
    write('Write the column of the piece.'),
    read_position_piece(Y,Height),
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
read_position_piece(Position,Coordinate) :-
    repeat,
    read_number(Position),
    Position>=1,
    Position=<Coordinate,
    !.

/*
    get what element is in the position of the coordinates
*/
get_position_piece(X,Y,Board,Piece) :-
    nth1(Y,Board,Row),
    nth1(X,Row,Piece).
