:- consult(move).

/*
    verifica se está numa situação onde o continuous jump é possivel
*/
check_continuous_jump_cycle(XP,YP,XM,YM,Turn,Height,Width,TotalMoves,Board,NewBoard) :-
    calculate_distances(XM,YM,Turn,Height,Width,Board,Distances),
    jump_possible(Distances,XP,YP,XM,YM),
    !,
    do_continuous_jump_cycle(XM,YM,Turn,Height,Width,TotalMoves,Board,NewBoard).

check_continuous_jump_cycle(_,_,_,_,_,_,_,_,Board,Board).

/*
    menu para se saber se quer fazer jump again e executa caso seja
*/
do_continuous_jump_cycle(XM,YM,Turn,Height,Width,TotalMoves,Board,NewBoard) :-
    menu_jump_cycle(Option),
    Option is 1,
    !,
    nl,
    display_game(Turn,Width,Board,TotalMoves),
    UpdatedTotalMoves is TotalMoves + 1,
    choose_jump(Turn,Height,Width,Board,XM,YM,NXM,NYM),
    move(Turn,XM,YM,NXM,NYM,Board,NewBoard),
    check_continuous_jump_cycle(XM,YM,NXM,NYM,Turn,Height,Width,UpdatedTotalMoves,NewBoard,NewNewBoard).

do_continuous_jump_cycle(_,_,_,_,_,_,Board,Board).

/*
    escolhe posição para onde mover, verificando que é um jump e se é possivel
*/
choose_jump(Turn,Height,Width,Board,XP,YP,XM,YM) :-
    repeat,
    calculate_distances(XP,YP,Turn,Height,Width,Board,Distances),
    select_jump(Turn,Height,Width,Board,XP,YP,XM,YM),
    check_move(XP,YP,XM,YM,Distances,Bool),
    Bool is 1,
    !.

/*
    escolhe posição para onde mover, verificando que é um jump
*/
select_jump(Turn,Height,Width,Board,XP,YP,XM,YM) :-
    repeat,
    write('\nSelect the coordinates to where you want to move.\n'),
    write('Column: '),
    read_column_piece(XM,Width),
    write('Row: '),
    read_row_piece(YM,Height),
    get_position_piece(XM,YM,Board,Piece),
    Turn \== Piece,
    \+no_jump(XP,YP,XM,YM),
    !.

/*
    menu para decidir entre fazer jump outra vez ou não
*/
menu_jump_cycle(Option) :-
    repeat,
    write('\n MENU CONTINUOUS JUMP \n'),
    write('Do you want to continue jumping?\n'),
    write('1: Yes\n'),
    write('2: No\n'),
    nl,
    write('Select the number of the option: '),
    read_number(Number),
    Number >= 0,
    Number =< 2,
    !,
    Option is Number.

menu_jump_cycle(Bool) :- Bool is 0.

/*
    verifica se está numa posição de continuous jump
*/
jump_possible(Distances,XP,YP,XM,YM) :-
    \+no_line(Distances),
    \+no_jump(XP,YP,XM,YM).

/*
    verifica que não há linhas para fazer jump
*/
no_line(Distances) :-
    nth1(1,Distances,Elem1),
    nth1(2,Distances,Elem2),
    nth1(3,Distances,Elem3),
    nth1(4,Distances,Elem4),
    Elem1 is 1,
    Elem2 is 1,
    Elem3 is 1,
    Elem4 is 1.

/*
    verifica que ultima movimentação foi do tipo adjacente
*/
no_jump(XP,YP,XM,YM) :-
    (
        (XP is XM+1, YP is YM);
        (XP is XM-1, YP is YM);
        (XP is XM, YP is YM+1);
        (XP is XM, YP is YM-1);

        (XP is XM+1, YP is YM+1);
        (XP is XM+1, YP is YM-1);
        (XP is XM-1, YP is YM+1);
        (XP is XM-1, YP is YM-1)
    ).



