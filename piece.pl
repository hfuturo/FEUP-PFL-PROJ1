:- consult(move).

/*
    choose piece to move and remove it from its place
*/
choose_move(Turn,Height,Width,Board,XP,YP,XM,YM) :-
    %repeat,
    select_piece(Turn,Height,Width,Board,XP,YP),
    select_move(Height,Width,XM,YM),
    check_move(XP,YP,XM,YM,Width,Height,Board,Turn,Bool).
    %change_piece(0,Board,X,Y,NewBoard).

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
    write('Row :'),
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
    write('Row :'),
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