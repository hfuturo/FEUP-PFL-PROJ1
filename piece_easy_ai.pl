:- use_module(library(random)).
:- consult(check_move).
:- consult(line_distance).
:- consult(piece).

/*
    Escolher um movimento a fazer em modo Easy AI
*/
select_random_move(Turn,Height,Width,Board,X,Y,XP,YP) :-
    repeat,
    random(1,Width,X),
    random(1,Height,Y),
    %format('X: ~w Y: ~w',[X,Y]),
    get_position_piece(X,Y,Board,Piece),
    Turn \== Piece,
    (XP \== X; YP \== Y),
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
    %write(X),
    %write(Y),nl,
    get_position_piece(X,Y,Board,Piece),
    Turn is Piece,
    !.

/*
    Escolher movimento na primeira jogada em modo Easy AI
*/
choose_random_move(Turn,Height,Width,Board,XP,YP,XM,YM,0) :-
    repeat,
    select_random_piece(Turn,Height,Width,Board,XP,YP),
    select_random_move(Turn,Height,Width,Board,XM,YM,XP,YP),
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
    select_random_move(Turn,Height,Width,Board,XM,YM,XP,YP),
    check_move_single_step(XP,YP,XM,YM,SBool),
    check_move(XP,YP,XM,YM,Distances,JBool),
    (SBool is 1; JBool is 1),
    !.

/*
    Verifica se está numa situação onde o continuous jump é possivel em modo Easy AI
*/
check_continuous_jump_cycle_random(XP,YP,XM,YM,Turn,Height,Width,TotalMoves,Board,NewBoard) :-
    calculate_distances(XM,YM,Turn,Height,Width,Board,Distances),
    jump_possible(Distances,XP,YP,XM,YM,Width,Height,Board,Turn),
    !,
    do_continuous_jump_cycle_random(XM,YM,Turn,Height,Width,TotalMoves,Board,NewBoard).

check_continuous_jump_cycle_random(_,_,_,_,_,_,_,_,Board,Board).

/*
    Fazer um continuous jump caso se queira em modo Easy AI
*/
do_continuous_jump_cycle_random(XM,YM,Turn,Height,Width,TotalMoves,Board,NewBoard) :-
    random(1,2,Option),
    Option is 1,
    !,
    nl,
    UpdatedTotalMoves is TotalMoves + 1,
    choose_jump_random(Turn,Height,Width,Board,XM,YM,NXM,NYM),
    move(Turn,XM,YM,NXM,NYM,Board,NewBoard),
    check_continuous_jump_cycle_random(XM,YM,NXM,NYM,Turn,Height,Width,UpdatedTotalMoves,NewBoard,NewNewBoard).

do_continuous_jump_cycle_random(_,_,_,_,_,_,Board,Board).

/*
    Escolher posição para onde mover, verificando que é um jump e se é possivel em modo Easy AI
*/
choose_jump_random(Turn,Height,Width,Board,XP,YP,XM,YM) :-
    repeat,
    calculate_distances(XP,YP,Turn,Height,Width,Board,Distances),
    select_random_move(Turn,Height,Width,Board,XM,YM,XP,YP),
    check_move(XP,YP,XM,YM,Distances,Bool),
    \+no_jump(XP,YP,XM,YM),
    Bool is 1,
    !.
