:- consult(check_move).
:- consult(line_distance).
:- consult(piece).
:- consult(menu).

/*
    Escolher movimento
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
    Escolher o movimento a fazer
*/
select_move(Turn,Height,Width,Board,X,Y,XP,YP) :-
    repeat,
    write('\n-----------------------------------------------------'),
    write('\n| Select the coordinates to where you want to move. |'),
    write('\n-----------------------------------------------------\n'),
    write('Column: '),
    read_column_piece(X,Width),
    write('Row: '),
    read_row_piece(Y,Height),
    get_position_piece(X,Y,Board,Piece),
    Turn =\= Piece,
    (XP =\= X; YP =\= Y),
    !.

/*
    Escolher a peça a mover
*/
select_piece(Turn,Height,Width,Board,X,Y) :-
    repeat,
    write('-----------------------------------------------------'),
    write('\n| Select the coordinates where the piece is.        |'),
    write('\n-----------------------------------------------------\n'),
    write('Column: '),
    read_column_piece(X,Width),
    write('Row: '),
    read_row_piece(Y,Height),
    get_position_piece(X,Y,Board,Piece),
    Turn is Piece,
    !.

/*
    Ler coordenada Y da peça
*/  
read_row_piece(Position,Coordinate) :-
    repeat,
    read_number(Position),
    Position>=1,
    Position=<Coordinate,
    !.

/*
    Ler coordenada X da peça
*/
read_column_piece(Position,Coordinate) :-
    repeat,
    read_char(Position),
    Position>=1,
    Position=<Coordinate,
    !.


/*
    verifica se está numa situação onde o continuous jump é possivel
*/
check_continuous_jump_cycle(XP,YP,XM,YM,Turn,Height,Width,TotalMoves,Board,NewBoard,VisitedPositions) :-
    calculate_distances(XM,YM,Turn,Height,Width,Board,Distances),
    jump_possible(Distances,XP,YP,XM,YM,Width,Height,Board,Turn,VisitedPositions),
    append(VisitedPositions,[XM,YM],NewVisitedPositions),
    !,
    do_continuous_jump_cycle(XM,YM,Turn,Height,Width,TotalMoves,Board,NewBoard,NewVisitedPositions).

check_continuous_jump_cycle(_,_,_,_,_,_,_,_,Board,Board,_).

/*
    menu para se saber se quer fazer jump again e executa caso seja
*/
do_continuous_jump_cycle(XM,YM,Turn,Height,Width,TotalMoves,Board,NewBoard,VisitedPositions) :-
    display_game(Turn,Width,Board,TotalMoves),
    menu_jump_cycle(Option),
    Option is 1,
    !,
    nl,
    display_game(Turn,Width,Board,TotalMoves),
    UpdatedTotalMoves is TotalMoves + 1,
    choose_jump(Turn,Height,Width,Board,XM,YM,NXM,NYM,VisitedPositions),
    move(Turn,XM,YM,NXM,NYM,Board,TempBoard),
    check_continuous_jump_cycle(XM,YM,NXM,NYM,Turn,Height,Width,UpdatedTotalMoves,TempBoard,NewBoard,VisitedPositions).

do_continuous_jump_cycle(_,_,_,_,_,_,Board,Board,_).


/*
    escolhe posição para onde mover, verificando que é um jump e se é possivel
*/
choose_jump(Turn,Height,Width,Board,XP,YP,XM,YM,VisitedPositions) :-
    repeat,
    calculate_distances(XP,YP,Turn,Height,Width,Board,Distances),
    select_move(Turn,Height,Width,Board,XM,YM,XP,YP),
    check_move(XP,YP,XM,YM,Distances,Bool),
    \+no_jump(XP,YP,XM,YM),
    \+member([XM,YM],VisitedPositions),
    Bool is 1,
    !.