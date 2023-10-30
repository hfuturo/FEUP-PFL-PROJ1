:- use_module(library(random)).
:- consult(check_move).
:- consult(line_distance).
:- consult(piece).

/*
    Escolher um movimento a fazer em modo Easy AI
*/
select_random_move(Turn,Height,Width,Board,X,Y,XP,YP,0) :-
    repeat,
    random(1,Width,X),
    random(1,Height,Y),
    get_position_piece(X,Y,Board,Piece),
    Turn \== Piece,
    (XP \== X; YP \== Y),
    !.

select_random_move(Turn,Height,Width,Board,X,Y,XP,YP,Distances) :-
    repeat,
    random(1,5,Move),
    nth1(Move,Distances,Distance),
    (
        (Move is 1, X is XP, Y is YP - Distance, Y >= 1, get_position_piece(X,Y,Board,Piece), Turn =\= Piece);  % up
        (Move is 1, X is XP, Y is YP + Distance, Y =< Height, get_position_piece(X,Y,Board,Piece), Turn =\= Piece);  % down
        (Move is 2, X is XP + Distance, Y is YP, X =< Width, get_position_piece(X,Y,Board,Piece), Turn =\= Piece);  % right
        (Move is 2, X is XP - Distance, Y is YP, X >= 1, get_position_piece(X,Y,Board,Piece), Turn =\= Piece);  % left
        (Move is 3, X is XP + Distance, Y is YP - Distance, X =< Width, Y >= 1, get_position_piece(X,Y,Board,Piece), Turn =\= Piece);  % NE
        (Move is 3, X is XP - Distance, Y is YP + Distance, X >= 1, Y =< Height, get_position_piece(X,Y,Board,Piece), Turn =\= Piece);  % SW
        (Move is 4, X is XP - Distance, Y is YP - Distance, X >= 1, Y >= 1, get_position_piece(X,Y,Board,Piece), Turn =\= Piece);  % NW
        (Move is 4, X is XP + Distance, Y is YP + Distance, X =< Width, Y =< Height, get_position_piece(X,Y,Board,Piece), Turn =\= Piece)  % SE
    ),
    !.

/*
    Escolher uma peça a mover em modo Easy AI
*/
select_random_piece(Turn,Height,Width,Board,X,Y) :-
    repeat,
    UpdatedWidth is Width + 1,
    UpdatedHeight is Height + 1,
    random(1,UpdatedWidth,X),
    random(1,UpdatedHeight,Y),
    get_position_piece(X,Y,Board,Piece),
    Turn is Piece,
    !.

/*
    Escolher movimento na primeira jogada em modo Easy AI
*/
choose_random_move(Turn,Height,Width,Board,XP,YP,XM,YM,0) :-
    repeat,
    select_random_piece(Turn,Height,Width,Board,XP,YP),
    select_random_move(Turn,Height,Width,Board,XM,YM,XP,YP,0),
    check_move_single_step(XP,YP,XM,YM,Bool),
    Bool is 1,
    !.

/*
    Escolher movimento aleatorio em modo Easy AI
*/
choose_random_move(Turn,Height,Width,Board,XP,YP,XM,YM,_) :-
    repeat,
    select_random_piece(Turn,Height,Width,Board,XP,YP),
    calculate_distances(XP,YP,Turn,Height,Width,Board,Distances),
    select_random_move(Turn,Height,Width,Board,XM,YM,XP,YP,Distances),
    check_move_single_step(XP,YP,XM,YM,SBool),
    check_move(XP,YP,XM,YM,Distances,JBool),
    (SBool is 1; JBool is 1),
    !.

/*
    Verifica se está numa situação onde o continuous jump é possivel em modo Easy AI
*/
check_continuous_jump_cycle_random(XP,YP,XM,YM,Turn,Height,Width,TotalMoves,Board,NewBoard,VisitedPositions) :-
    calculate_distances(XM,YM,Turn,Height,Width,Board,Distances),
    jump_possible(Distances,XP,YP,XM,YM,Width,Height,Board,Turn,VisitedPositions),
    append(VisitedPositions,[XM,YM],NewVisitedPositions),
    !,
    do_continuous_jump_cycle_random(XM,YM,Turn,Height,Width,TotalMoves,Board,NewBoard,NewVisitedPositions).

check_continuous_jump_cycle_random(_,_,_,_,_,_,_,_,Board,Board,_).

/*
    Fazer um continuous jump caso se queira em modo Easy AI
*/
do_continuous_jump_cycle_random(XM,YM,Turn,Height,Width,TotalMoves,Board,NewBoard,VisitedPositions) :-
    random(1,3,Option),
    Option is 1,
    !,
    nl,
    UpdatedTotalMoves is TotalMoves + 1,
    choose_jump_random(Turn,Height,Width,Board,XM,YM,NXM,NYM,VisitedPositions),
    move(Turn,XM,YM,NXM,NYM,Board,TempBoard),
    display_game(Turn,Width,TempBoard,TotalMoves),
    check_continuous_jump_cycle_random(XM,YM,NXM,NYM,Turn,Height,Width,UpdatedTotalMoves,TempBoard,NewBoard,VisitedPositions).

do_continuous_jump_cycle_random(_,_,_,_,_,_,Board,Board,_).

/*
    Escolher posição para onde mover, verificando que é um jump e se é possivel em modo Easy AI
*/
choose_jump_random(Turn,Height,Width,Board,XP,YP,XM,YM,VisitedPositions) :-
    repeat,
    calculate_distances(XP,YP,Turn,Height,Width,Board,Distances),
    select_random_move(Turn,Height,Width,Board,XM,YM,XP,YP,Distances),
    check_move(XP,YP,XM,YM,Distances,Bool),
    \+no_jump(XP,YP,XM,YM),
    \+member([XM,YM],VisitedPositions),
    Bool is 1,
    !.
