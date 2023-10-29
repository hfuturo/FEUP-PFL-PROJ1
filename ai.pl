:- use_module(library(random)).


/*
    escolher um movimento aleatorio a fazer
*/
select_random_move(Turn,Height,Width,Board,X,Y,XP,YP) :-
    repeat,
    random(1,Width,X),
    random(1,Height,Y),
    get_position_piece(X,Y,Board,Piece),
    Turn \== Piece,
    (XP \== X; YP \== Y),
    !.

/*
    escolher uma peça aleatorio a mover
*/
select_random_piece(Turn,Height,Width,Board,X,Y) :-
    repeat,
    random(1,Width,X),
    random(1,Height,Y),
    get_position_piece(X,Y,Board,Piece),
    Turn is Piece,
    !.

/*
    escolher movimento na primeira jogada
*/
choose_random_move(Turn,Height,Width,Board,XP,YP,XM,YM,0) :-
    repeat,
    select_random_piece(Turn,Height,Width,Board,XP,YP),
    select_random_move(Turn,Height,Width,Board,XM,YM,XP,YP),
    check_move_single_step(XP,YP,XM,YM,Bool),
    Bool is 1,
    !.

/*
    escolher movimento
*/
choose_random_move(Turn,Height,Width,Board,XP,YP,XM,YM,_) :-
    repeat,
    select_random_piece(Turn,Height,Width,Board,XP,YP),
    calculate_distances(XP,YP,Turn,Height,Width,Board,Distances),
    select_random_move(Turn,Height,Width,Board,XM,YM,XP,YP),
    check_move(XP,YP,XM,YM,Distances,Bool),
    Bool is 1,
    !.