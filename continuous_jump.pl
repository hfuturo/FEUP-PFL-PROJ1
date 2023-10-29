:- consult(check_move).

/*
    verifica se está numa situação onde o continuous jump é possivel
*/
check_continuous_jump_cycle(XP,YP,XM,YM,Turn,Height,Width,TotalMoves,Board,NewBoard) :-
    calculate_distances(XM,YM,Turn,Height,Width,Board,Distances),
    jump_possible(Distances,XP,YP,XM,YM,Width,Height,Board,Turn),
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
    select_move(Turn,Height,Width,Board,XM,YM,XP,YP),
    check_move(XP,YP,XM,YM,Distances,Bool),
    \+no_jump(XP,YP,XM,YM),
    Bool is 1,
    !.

/*
    menu para decidir entre fazer jump outra vez ou não
*/
menu_jump_cycle(Option) :-
    repeat,
    write('\n-----------------------------------|'),
    write('\n|       MENU CONTINUOUS JUMP       |'),
    write('\n| Do you want to continue jumping? |'),
    write('\n| 1: Yes                           |'),
    write('\n| 2: No                            |'),
    write('\n-----------------------------------|'), nl,
    write('Select the number of the option: '),
    read_number(Number),
    Number > 0,
    Number =< 2,
    !,
    Option is Number.

/*
    verifica se está numa posição de continuous jump
*/
jump_possible(Distances,XP,YP,XM,YM,Width,Height,Board,Turn) :-
    \+no_line(Distances),
    \+no_jump(XP,YP,XM,YM),
    can_jump(Distances,XP,YP,XM,YM,Width,Height,Board,Turn).

can_jump(Distances,XP,YP,XM,YM,Width,Height,Board,Turn) :-
    nth1(1,Distances,Vertical),
    nth1(2,Distances,Horizontal),
    nth1(3,Distances,DiagonalNE),
    nth1(4,Distances,DiagonalNW),

    (
        % vertical
        (
            % up
            (
                Vertical > 1,
                1 =< YM - Vertical,
                UpdatedY is YM - Vertical,
                nth1(UpdatedY,Board,Row),
                nth1(XM,Row,XVal),
                Turn =\= XVal,
                UpdatedY =\= YP
            );

            % down
            (
                Vertical > 1,
                Height >= YM + Vertical,
                UpdatedY is YM + Vertical,
                nth1(UpdatedY,Board,Row),
                nth1(XM,Row,XVal),
                Turn =\= XVal,
                UpdatedY =\= YP
            )
        );

        % horizontal
        (
            % right
            (
                Horizontal > 1,
                Width >= XM + Horizontal,
                UpdatedX is XM + Horizontal,
                nth1(Y,Board,Row),
                nth1(UpdatedX,Row,XVal),
                Turn =\= XVal,
                UpdatedX =\= XP
            );

            % left      
            (
                Horizontal > 1,
                1 =< XM - Horizontal,
                UpdatedX is XM - Horizontal,
                nth1(Y,Board,Row),
                nth1(UpdatedX,Row,XVal),
                Turn =\= XVal,
                UpdatedX =\= XP
            )
        );

        % diagonal NE-SW
        (
            % NE
            (
                DiagonalNE > 1,
                1 =< YM - DiagonalNE,
                Width >= XM + DiagonalNE,
                UpdatedY is YM - DiagonalNE,
                UpdatedX is XM + DiagonalNE,
                nth1(UpdatedY,Board,Row),
                nth1(UpdatedX,Row,XVal),
                Turn =\= XVal,
                (   % necessário verificar se novo jump não é a coord anterior
                    UpdatedY =\= YP ; UpdatedX =\= XP
                )
            );

            % SW
            (
                DiagonalNE > 1,
                Height >= YM + DiagonalNE,
                1 =< XM - DiagonalNE,
                UpdatedY is YM + DiagonalNE,
                UpdatedX is XM - DiagonalNE,
                nth1(UpdatedY,Board,Row),
                nth1(UpdatedX,Row,XVal),
                Turn =\= XVal,
                (   % necessário verificar se novo jump não é a coord anterior
                    UpdatedY =\= YP ; UpdatedX =\= XP
                )
            )
        );

        % diagonal NW-SE
        (
            % NW
            (
                DiagonalNW > 1,
                1 =< YM - DiagonalNW,
                1 =< XM - DiagonalNW,
                UpdatedY is YM - DiagonalNW,
                UpdatedX is XM - DiagonalNW,
                nth1(UpdatedY,Board,Row),
                nth1(UpdatedX,Row,XVal),
                Turn =\= XVal,
                (   % necessário verificar se novo jump não é a coord anterior
                    UpdatedY =\= YP ; UpdatedX =\= XP
                )
            );

            % SE
            (
                DiagonalNW > 1,
                Height >= YM + DiagonalNW,
                Width >= XM + DiagonalNW,
                UpdatedY is YM + DiagonalNW,
                UpdatedX is XM + DiagonalNW,
                nth1(UpdatedY,Board,Row),
                nth1(UpdatedX,Row,XVal),
                Turn =\= XVal,
                (   % necessário verificar se novo jump não é a coord anterior
                    UpdatedY =\= YP ; UpdatedX =\= XP
                )
            )
        )                
    ).

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



