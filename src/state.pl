:- use_module(library(system)).

:- consult(utils).
:- consult(board).
:- consult(check_win).
:- consult(piece).
:- consult(move).

/*
    Cria um tabuleiro com um tamanho especifico
    initial_state(-Height,-Width,-Board)
*/
initial_state(Height,Width,Board) :-
    read_size_board(Height,Width),
    make_initial_board(Height,Width,Board), nl.

/*
    Faz o output do estado atual do jogo
    display_game(+Turn,+Width,+Board,+TotalMoves)
*/
display_game(Turn,Width,Board,TotalMoves) :-
    print_board(Board,Width,Turn,TotalMoves),
    !.   % remove output true ? do terminal quando acaba de correr

/*
    Faz o output do estado atual do jogo com a indicação da ronda
    display_game_with_round(+Player,+Width,+Board,+TotalMoves,+Round)
*/
display_game_with_round(1,Width,Board,TotalMoves,Round) :-
    Round < 10,
    write('**************\n'),
    write('*            *\n'),
    format('*   Round ~w  *\n',Round),
    write('*            *\n'),
    write('**************\n'),
    display_game(1,Width,Board,TotalMoves),
    !.

display_game_with_round(1,Width,Board,TotalMoves,Round) :-
    Round >= 10,
    Round < 100,
    write('***************\n'),
    write('*             *\n'),
    format('*   Round ~w  *\n',Round),
    write('*             *\n'),
    write('***************\n'),
    display_game(1,Width,Board,TotalMoves),
    !.

display_game_with_round(1,Width,Board,TotalMoves,Round) :-
    Round >= 100,
    Round < 1000,
    write('****************\n'),
    write('*              *\n'),
    format('*   Round ~w  *\n',Round),
    write('*              *\n'),
    write('****************\n'),
    display_game(1,Width,Board,TotalMoves),
    !.

display_game_with_round(2,Width,Board,TotalMoves,_) :-
    display_game(2,Width,Board,TotalMoves).


/*
    Ciclo do jogo
    game_cycle(+Turn,+Height,+Width,+Board,+TotalMoves,+Mode,+Round)
*/

/* verifica se existe um vencedor */
game_cycle(Turn,Height,Width,Board,_,_,_):- 
    game_over(Board,Width,Height,Turn,Winner), 
    !, 
    congratulate(Winner).

/* na primeira jogada não é possivel fazer continuous jump */
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
    Verificar se o jogo acabou, e se sim vê quem ganhou
    game_over(+Board,+Width,+Height,+Turn,-Winner)
*/
game_over(Board,Width,Height,Turn,Winner) :-
    change_player(Turn,NewTurn),
    Y is 1,
    \+check_winner(Board,Width,Height,Y,Turn),
    !,
    check_winner(Board,Width,Height,Y,NewTurn),
    Winner is NewTurn.

game_over(_,_,_,Turn,Turn).

/*
    Congratula o vencedor
    congratulate(+Winner)
*/
congratulate(Winner) :-
    format('Player ~w won!',Winner).

