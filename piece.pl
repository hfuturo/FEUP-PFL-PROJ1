/*
    choose piece to move and remove it from its place
*/
choose_move(Turn,Height,Width,Board,NewBoard) :-
    %repeat,
    select_piece(Turn,Height,Width,Board,XP,YP),
    %select_move(Height,Width,XM,YM),
    %check_move(XP,YP,XM,YM,Board).
    %check_row(XP,YP,Board,Width,Turn),
    change_piece(0,Board,X,Y,NewBoard).

check_row(XP,YP,Board,Width,Turn) :-
    nth1(YP,Board,Row),
    Number is 0,
    check_row_positive_aux(XP,Width,Number,Row,Turn),
    format('~w\n',Number),
    check_row_negative_aux(XP,0,Number,Row,Turn).

check_row_positive_aux(Width,Width,_,_,_) .
check_row_positive_aux(XP,Width,Number,Row,Turn) :- 
    nth1(XP,Row,Value),
    player(Value,Turn),
    !,
    NewNumber is Number+1,
    NewXP is XP+1, 
    check_row_positive_aux(NewXP,Width,NewNumber,Row,Turn).

check_row_negative_aux(0,_,_,_,_).
check_row_negative_aux(XP,Min,Number,Row,Turn) :-
    nth1(XP,Row,Value),
    \+player(Value,Turn),
    !,
    NewNumber is Number+1,
    NewXP is XP-1, 
    check_row_negative_aux(NewXP,Min,NewNumber,Row,Turn).


/*
    choose move to make and do the action
*/
move(Turn,Height,Width,Board,NewBoard) :-
    select_move(Height,Width,X,Y),
    change_piece(Turn,Board,X,Y,NewBoard).

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

player(1,1).
player(2,2).