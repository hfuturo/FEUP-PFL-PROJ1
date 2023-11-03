:- use_module(library(system)).

:- consult(utils).
:- consult(board).
:- consult(check_win).
:- consult(piece).
:- consult(move).

/*
    Cria um tabuleiro com um tamanho especifico
    initial_state(-GameState)
*/
initial_state((Board,Turn,TotalMoves)) :-
    TotalMoves is 0,
    Turn is 1,
    read_size_board(Height,Width),
    make_initial_board(Height,Width,Board), nl.

/*
    Faz o output do estado atual do jogo
    display_game(+GameState)
*/
display_game(GameState) :-
    print_board(GameState),
    !.
    
/*
    Faz o output do estado atual do jogo com a indicação da ronda
    display_game_with_round(+GameState,+Round)
*/
% caso a Round seja < 10 (formatacao)
display_game_with_round((Board,1,TotalMoves),Round) :-
    Round < 10,
    write('**************\n'),
    write('*            *\n'),
    format('*   Round ~w  *\n',Round),
    write('*            *\n'),
    write('**************\n'),
    display_game((Board,1,TotalMoves)),
    !.

% caso a Round seja >= 10 e < 100 (formatacao)
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

% caso a Round seja >= 100 e < 1000 (formatacao)
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
    game_cycle(+GameState,+Mode,+Round)
*/

/* verifica se existe um vencedor */
game_cycle(GameState,_,_):- 
    game_over(GameState,Winner), 
    !, 
    congratulate(Winner).

/* na primeira jogada não é possivel fazer continuous jump */
game_cycle((Board,Turn,0),Mode,Round):-
    player_type(Mode,Turn,Type),

    choose_move( (Board,Turn,0), [], Type, (XP,YP,XM,YM)),
    move((Board,Turn,0),(XP,YP,XM,YM),(NewBoard,_,NewTotalMoves)),
    append([[XP,YP],[XM,YM]],[],VisitedPositions),
    display_moves((Board,Turn,0),VisitedPositions,Type),

    change_player(Turn,NewTurn),
    change_round(NewTurn,Round,NewRound),
    display_game_with_round((NewBoard,NewTurn,NewTotalMoves),NewRound),
    !,
    game_cycle((NewBoard,NewTurn,NewTotalMoves),Mode,NewRound).


game_cycle((Board,Turn,TotalMoves),Mode,Round):-
    player_type(Mode,Turn,Type),

    choose_move((Board,Turn,_), [], Type, (XP,YP,XM,YM)),
    move((Board,Turn,TotalMoves),(XP,YP,XM,YM),TempGameState),
    append([[XP,YP],[XM,YM]],[],VisitedPositions),
    display_moves((Board,Turn,TotalMoves),VisitedPositions,Type),

    check_continuous_jump_cycle((XP,YP,XM,YM),TempGameState,(NewBoard,_,NewTotalMoves),VisitedPositions,Type),
    change_player(Turn,NewTurn),
    change_round(NewTurn,Round,NewRound),
    display_game_with_round((NewBoard,NewTurn,NewTotalMoves),NewRound),
    !,
    game_cycle((NewBoard,NewTurn,NewTotalMoves),Mode,NewRound).


/*
    Verificar se o jogo acabou, e se sim vê quem ganhou
    game_over(+GameState,-Winner)
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

/*
    Avalia o estado do jogo
    value(+GameState, +Player, -Value)
*/
value((Board,Turn,_),Value) :-
    change_player(Turn,NewTurn),
    check_winner(Board,1,NewTurn),
    !,
    Value is 0.

value((Board,Turn,_),Value) :-
    check_winner(Board,1,Turn),
    !,
    Value is 10.

value(_,Value) :- Value is 5.

