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
initial_state((Board,Turn,TotalMoves)) :-
    TotalMoves is 0,
    Turn is 1,
    read_size_board(Height,Width),
    make_initial_board(Height,Width,Board), nl.

/*
    Faz o output do estado atual do jogo
    display_game(+Turn,+Width,+Board,+TotalMoves)
*/
display_game(GameState) :-
    print_board(GameState),
    !.
    
/*
    Faz o output do estado atual do jogo com a indicação da ronda
    display_game_with_round(+Player,+Width,+Board,+TotalMoves,+Round)
*/
display_game_with_round((Board,1,TotalMoves),Round) :-
    Round < 10,
    write('**************\n'),
    write('*            *\n'),
    format('*   Round ~w  *\n',Round),
    write('*            *\n'),
    write('**************\n'),
    display_game((Board,1,TotalMoves)),
    !.

display_game_with_round((Board,1,TotalMoves),Round) :-
    Round >= 10,
    Round < 100,
    write('***************\n'),
    write('*             *\n'),
    format('*   Round ~w  *\n',Round),
    write('*             *\n'),
    write('***************\n'),
    display_game((Board,1,TotalMoves)),
    !.

display_game_with_round((Board,1,TotalMoves),Round) :-
    Round >= 100,
    Round < 1000,
    write('****************\n'),
    write('*              *\n'),
    format('*   Round ~w  *\n',Round),
    write('*              *\n'),
    write('****************\n'),
    display_game((Board,1,TotalMoves)),
    !.

display_game_with_round((Board,2,TotalMoves),_) :-
    display_game((Board,2,TotalMoves)).

/*
    Ciclo do jogo
    game_cycle(+Turn,+Height,+Width,+Board,+TotalMoves,+Mode,+Round)
*/

/* verifica se existe um vencedor */
game_cycle(GameState,_,_):- 
    game_over(GameState,Winner), 
    !, 
    congratulate(Winner).

/* na primeira jogada não é possivel fazer continuous jump */
game_cycle((Board,Turn,0),Mode,Round):-
    player_type(Mode,Turn,Type),
    append([],[],VisitedPositions),
    choose_move( (Board,Turn,0), (VisitedPositions,ContinuousJump,XL,YL), Type, Move),
    move((Board,Turn,0),Move,(NewBoard,_,NewTotalMoves)),
    change_player(Turn,NewTurn),
    change_round(NewTurn,Round,NewRound),
    display_game_with_round((NewBoard,NewTurn,NewTotalMoves),NewRound),
    !,
    game_cycle((NewBoard,NewTurn,NewTotalMoves),Mode,NewRound).


game_cycle((Board,Turn,TotalMoves),Mode,Round):-
    player_type(Mode,Turn,Type),
    append([],[],InitialVisitedPoints),
    choose_move( (Board,Turn,0), (InitialVisitedPoints,ContinuousJump,XL,YL), Type, (XP,YP,XM,YM)),
    move((Board,Turn,TotalMoves),(XP,YP,XM,YM),TempGameState),
    append([[XP,YP]],[],VisitedPositions),
    check_continuous_jump_cycle((XP,YP,XM,YM),TempGameState,(NewBoard,_,NewTotalMoves),VisitedPositions,Type),
    change_player(Turn,NewTurn),
    change_round(NewTurn,Round,NewRound),
    display_game_with_round((NewBoard,NewTurn,NewTotalMoves),NewRound),
    !,
    game_cycle((NewBoard,NewTurn,NewTotalMoves),Mode,NewRound).


/*
    Verificar se o jogo acabou, e se sim vê quem ganhou
    game_over(+Board,+Width,+Height,+Turn,-Winner)
*/
game_over((Board,Turn,_),Winner) :-
    change_player(Turn,NewTurn),
    Y is 1,
    \+check_winner(Board,Y,Turn),
    !,
    check_winner(Board,Y,NewTurn),
    Winner is NewTurn.

game_over((_,Turn,_),Turn).

/*
    Congratula o vencedor
    congratulate(+Winner)
*/
congratulate(Winner) :-
    format('Player ~w won!',Winner).

