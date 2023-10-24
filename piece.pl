/*
    select the piece that the player wants to move
*/
select_piece(Turn,Hight,Wide,Board) :-
    repeat,
    write('\nSelect the coordinates where the piece is.\n'),
    write('Write the row of the piece.'),
    read_position_piece(X,Wide),
    write('Write the column of the piece.'),
    read_position_piece(Y,Hight),
    get_position_piece(X,Y,Board,Piece),
    Turn is Piece,
    !.

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
