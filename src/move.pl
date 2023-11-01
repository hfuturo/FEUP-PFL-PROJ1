:- use_module(library(system)).
:- use_module(library(random)).
:- use_module(library(lists)).
:- use_module(library(between)).

:- consult(check_move).
:- consult(check_isolation).
:- consult(distance).
:- consult(piece).
:- consult(menu).

/* modo pessoa */
select_piece(Turn,Height,Width,Board,X,Y,1) :-
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

/* modo easy ai */
select_piece(Turn,Height,Width,Board,X,Y,2) :-
    repeat,
    UpdatedWidth is Width + 1,
    UpdatedHeight is Height + 1,
    random(1,UpdatedWidth,X),
    random(1,UpdatedHeight,Y),
    get_position_piece(X,Y,Board,Piece),
    Turn is Piece,
    !.

/* modo pessoa */
select_move(Turn,Height,Width,Board,X,Y,XP,YP,_,_,1) :-
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

/* modo easy ai */
select_move(Turn,Height,Width,Board,X,Y,XP,YP,Distances,VisitedPositions,2) :-
    repeat,
    random(1,5,Move),
    nth1(Move,Distances,Distance),
    (
        (Move is 1, X is XP, Y is YP - Distance, Y >= 1, get_position_piece(X,Y,Board,Piece), Turn =\= Piece, \+member([X,Y],VisitedPositions));  % up
        (Move is 1, X is XP, Y is YP + Distance, Y =< Height, get_position_piece(X,Y,Board,Piece), Turn =\= Piece, \+member([X,Y],VisitedPositions));  % down
        (Move is 2, X is XP + Distance, Y is YP, X =< Width, get_position_piece(X,Y,Board,Piece), Turn =\= Piece, \+member([X,Y],VisitedPositions));  % right
        (Move is 2, X is XP - Distance, Y is YP, X >= 1, get_position_piece(X,Y,Board,Piece), Turn =\= Piece, \+member([X,Y],VisitedPositions));  % left
        (Move is 3, X is XP + Distance, Y is YP - Distance, X =< Width, Y >= 1, get_position_piece(X,Y,Board,Piece), Turn =\= Piece, \+member([X,Y],VisitedPositions));  % NE
        (Move is 3, X is XP - Distance, Y is YP + Distance, X >= 1, Y =< Height, get_position_piece(X,Y,Board,Piece), Turn =\= Piece, \+member([X,Y],VisitedPositions));  % SW
        (Move is 4, X is XP - Distance, Y is YP - Distance, X >= 1, Y >= 1, get_position_piece(X,Y,Board,Piece), Turn =\= Piece, \+member([X,Y],VisitedPositions));  % NW
        (Move is 4, X is XP + Distance, Y is YP + Distance, X =< Width, Y =< Height, get_position_piece(X,Y,Board,Piece), Turn =\= Piece, \+member([X,Y],VisitedPositions))  % SE
    ),
    !.


/* modo pessoa ou easy ai */
choose_move(Turn,Height,Width,Board,XP,YP,XM,YM,VisitedPositions,Type) :-
    (Type is 1;Type is 2),
    repeat,
    append([],[],VisitedPositions),
    (Type is 1; Type is 2),
    repeat,
    select_piece(Turn,Height,Width,Board,XP,YP,Type),
    calculate_distances(XP,YP,Turn,Height,Width,Board,Distances),
    select_move(Turn,Height,Width,Board,XM,YM,XP,YP,Distances,VisitedPositions,Type),
    check_move(XP,YP,XM,YM,Distances,Bool),
    Bool is 1,
    !.

choose_move(Turn,Height,Width,Board,XP,YP,XM,YM,_,3) :-
    findall(
        [Value,X,Y], 
        (
            between(1, Width, X), 
            between(1, Height, Y), 
            get_position_player(X, Y, Board, Turn),
            check_isolation_move(X,Y,Value,Height,Width,Board,Turn,0)
        ), 
        Pieces
    ),
    sort(Pieces, SortedPieces),
    length(SortedPieces,MaxIndex),
    nth1(MaxIndex,SortedPieces,Elem),
    nth1(1,Elem,MaxValue),
    findall(
        [Value,X,Y],
        (
            member([Value,X,Y],Pieces),
            Value =:= MaxValue
        ),
        PossibleMoves
    ),
    sort(PossibleMoves,PossibleMovesNoRepeated),
    length(PossibleMovesNoRepeated,PossibleMovesLength),
    UpdatedPossibleMovesLength is PossibleMovesLength + 1,
    random(1,UpdatedPossibleMovesLength,RandomMove),
    nth1(RandomMove,PossibleMovesNoRepeated,SelectedMove),
    nth1(2,SelectedMove,XP),
    nth1(3,SelectedMove,YP),
    check_isolation_piece(Turn,Height,Width,Board,XP,YP,XM,YM).

/* modo pessoa ou easy ai */
choose_jump(Turn,Height,Width,Board,XP,YP,XM,YM,VisitedPositions,Type) :-
    (Type is 1; Type is 2),
    repeat,
    calculate_distances(XP,YP,Turn,Height,Width,Board,Distances),
    select_move(Turn,Height,Width,Board,XM,YM,XP,YP,Distances,VisitedPositions,Type),
    check_move(XP,YP,XM,YM,Distances,Bool),
    \+no_jump(XP,YP,XM,YM),
    \+member([XM,YM],VisitedPositions),
    Bool is 1,
    !.

/* modo pessoa ou easy ai */
check_continuous_jump_cycle(XP,YP,XM,YM,Turn,Height,Width,TotalMoves,NewTotalMoves,Board,NewBoard,VisitedPositions,Type) :-
    calculate_distances(XM,YM,Turn,Height,Width,Board,Distances),
    jump_possible(Distances,XP,YP,XM,YM,Width,Height,Board,Turn,VisitedPositions),
    append(VisitedPositions,[[XM,YM]],NewVisitedPositions),
    !,
    do_continuous_jump_cycle(XM,YM,Turn,Height,Width,TotalMoves,NewTotalMoves,Board,NewBoard,NewVisitedPositions,Type).

check_continuous_jump_cycle(_,_,_,_,_,_,_,NewTotalMoves,NewTotalMoves,Board,Board,_,_).

do_continuous_jump_cycle(XM,YM,Turn,Height,Width,TotalMoves,NewTotalMoves,Board,NewBoard,VisitedPositions,Type) :-
    (Type is 1;Type is 2),
    display_game(Turn,Width,Board,TotalMoves),
    menu_jump_cycle(Option,Type),
    Option is 1,
    !,
    nl,
    TempTotalMoves is TotalMoves + 1,
    choose_jump(Turn,Height,Width,Board,XM,YM,NXM,NYM,VisitedPositions,Type),
    move(Turn,XM,YM,NXM,NYM,Board,TempBoard),
    check_continuous_jump_cycle(XM,YM,NXM,NYM,Turn,Height,Width,TempTotalMoves,NewTotalMoves,TempBoard,NewBoard,VisitedPositions,Type).

do_continuous_jump_cycle(XM,YM,Turn,Height,Width,TotalMoves,NewTotalMoves,Board,NewBoard,VisitedPositions,3) :-
    display_game(Turn,Width,Board,TotalMoves),
    check_isolation_move(XM,YM,Isolation,Height,Width,Board,Turn,0),
    check_isolation_jump(Turn,Height,Width,Board,XM,YM,NXM,NYM,Min,VisitedPositions),
    (
        NXM =\= 0,
        NYM =\=0,
        Isolation>Min
    ),
    !,
    TempTotalMoves is TotalMoves + 1,
    move(Turn,XM,YM,NXM,NYM,Board,TempBoard),
    check_continuous_jump_cycle(XM,YM,NXM,NYM,Turn,Height,Width,TempTotalMoves,NewTotalMoves,TempBoard,NewBoard,VisitedPositions,3).

do_continuous_jump_cycle(_,_,_,_,_,NewTotalMoves,NewTotalMoves,Board,Board,_,_).
