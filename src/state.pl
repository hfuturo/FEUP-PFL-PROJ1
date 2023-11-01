:- use_module(library(system)).

:- consult(utils).
:- consult(board).
:- consult(check_win).
:- consult(piece).
:- consult(move).

/* modo pessoa */
player_type(Mode,Turn,Type) :-
    (
        (Mode is 1);
        (Mode is 2, Turn is 1);
        (Mode is 3, Turn is 2);
        (Mode is 5, Turn is 1);
        (Mode is 6, Turn is 2)
    ),
    !,
    Type is 1.

/* modo easy ai */
player_type(Mode,Turn,Type) :-
    (
        (Mode is 2, Turn is 2);
        (Mode is 3, Turn is 1);
        (Mode is 4);
        (Mode is 7, Turn is 1);
        (Mode is 8, Turn is 2)
    ),
    !,
    Type is 2.

/* modo difficult ai */
player_type(Mode,Turn,Type) :-
    (
        (Mode is 5, Turn is 2);
        (Mode is 6, Turn is 1);
        (Mode is 7, Turn is 2);
        (Mode is 8, Turn is 1);
        (Mode is 9)
    ),
    !,
    Type is 3.

/*
    criar um tabuleiro com um tamanho especifico
*/
initial_state(Height,Width,Board) :-
    read_size_board(Height,Width),
    make_initial_board(Height,Width,Board), nl.
/*
    print do tabuleiro
*/
display_game(Turn,Width,Board,TotalMoves) :-
    print_board(Board,Width,Turn,TotalMoves),
    !.   % remove output true ? do terminal quando acaba de correr

display_game_with_round(1,Width,NewBoard,NewTotalMoves,Round) :-
    Round < 10,
    write('**************\n'),
    write('*            *\n'),
    format('*   Round ~w  *\n',Round),
    write('*            *\n'),
    write('**************\n'),
    display_game(1,Width,NewBoard,NewTotalMoves),
    !.

display_game_with_round(1,Width,NewBoard,NewTotalMoves,Round) :-
    Round >= 10,
    Round < 100,
    write('***************\n'),
    write('*             *\n'),
    format('*   Round ~w  *\n',Round),
    write('*             *\n'),
    write('***************\n'),
    display_game(1,Width,NewBoard,NewTotalMoves),
    !.

display_game_with_round(1,Width,NewBoard,NewTotalMoves,Round) :-
    Round >= 100,
    Round < 1000,
    write('****************\n'),
    write('*              *\n'),
    format('*   Round ~w  *\n',Round),
    write('*              *\n'),
    write('****************\n'),
    display_game(1,Width,NewBoard,NewTotalMoves),
    !.

display_game_with_round(2,Width,NewBoard,NewTotalMoves,_) :-
    display_game(2,Width,NewBoard,NewTotalMoves).


/*
    verificar se o jogo acabou e congratular o vencedor
*/
game_cycle(Turn,Height,Width,Board,_,_,_):- 
    game_over(Board,Width,Height,Turn,Winner), 
    !, 
    congratulate(Winner).

/*
    ciclo do jogo -> primeira jogada
*/
game_cycle(Turn,Height,Width,Board,0,Mode,Round):-
    player_type(Mode,Turn,Type),
    choose_move(Turn,Height,Width,Board,XP,YP,XM,YM,_,Type),
    move(Turn,XP,YP,XM,YM,Board,NewBoard),
    change_player(Turn,NewTurn),
    change_round(NewTurn,Round,NewRound),
    display_game_with_round(NewTurn,Width,NewBoard,1,NewRound),
    !,
    game_cycle(NewTurn,Height,Width,NewBoard,1,Mode,NewRound).


game_cycle(Turn,Height,Width,Board,TotalMoves,Mode,Round):-
    player_type(Mode,Turn,Type),
    choose_move(Turn,Height,Width,Board,XP,YP,XM,YM,_,Type),
    move(Turn,XP,YP,XM,YM,Board,TempBoard),
    TempTotalMoves is TotalMoves + 1,
    append([[XP,YP]],[],VisitedPositions),
    check_continuous_jump_cycle(XP,YP,XM,YM,Turn,Height,Width,TempTotalMoves,NewTotalMoves,TempBoard,NewBoard,VisitedPositions,Type),
    change_player(Turn,NewTurn),
    change_round(NewTurn,Round,NewRound),
    display_game_with_round(NewTurn,Width,NewBoard,NewTotalMoves,NewRound),
    !,
    game_cycle(NewTurn,Height,Width,NewBoard,NewTotalMoves,Mode,NewRound).

/*
    verificar se o jogo acabou, e se sim ver quem ganhou
*/
game_over(Board,Width,Height,Turn,Winner) :-
    change_player(Turn,NewTurn),
    Y is 1,
    \+check_winner(Board,Width,Height,Y,Turn),
    !,
    check_winner(Board,Width,Height,Y,NewTurn),
    Winner is NewTurn.

game_over(_,_,_,Turn,Turn).

congratulate(Winner) :-
    format('Player ~w won!',Winner).

