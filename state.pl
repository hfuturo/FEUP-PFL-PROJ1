:- use_module(library(system)).

:- consult(utils).
:- consult(board).
:- consult(check_win).
:- consult(piece_person).
:- consult(piece_easy_ai).
:- consult(piece_difficult_ai).
:- consult(piece).

change_player(1,2).
change_player(2,1).

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

/*
    verificar se o jogo acabou e congratular o vencedor
*/
game_cycle(Turn,Height,Width,Board,_,_):- 
    game_over(Board,Width,Height,Turn,Winner), 
    !, 
    congratulate(Winner).


/*
    ciclo do jogo -> primeira jogada
*/
game_cycle(Turn,Height,Width,Board,0,Mode):-
    (
        (Mode is 1);
        (Mode is 2, Turn is 1);
        (Mode is 3, Turn is 2);
        (Mode is 5, Turn is 1);
        (Mode is 6, Turn is 2)
    ),
    choose_move(Turn,Height,Width,Board,XP,YP,XM,YM,0),
    move(Turn,XP,YP,XM,YM,Board,NewBoard),
    append([[XP,YP]],[],VisitedPositions),
    change_player(Turn,NewTurn),
    display_game(NewTurn,Width,NewBoard,1),
    !,
    game_cycle(NewTurn,Height,Width,NewBoard,1,Mode).

/*
    ciclo de jogo em modo Easy AI -> primeira jogada
*/
game_cycle(Turn,Height,Width,Board,0,Mode) :-
    (
        (Mode is 2, Turn is 2);
        (Mode is 3, Turn is 1);
        (Mode is 4);
        (Mode is 7, Turn is 1);
        (Mode is 8, Turn is 2)
    ),
    choose_random_move(Turn,Height,Width,Board,XP,YP,XM,YM,[]),
    move(Turn,XP,YP,XM,YM,Board,NewBoard),
    append([[XP,YP]],[],VisitedPositions),
    change_player(Turn,NewTurn),
    display_game(NewTurn,Width,NewBoard,1),
    %sleep(3),
    !,
    game_cycle(NewTurn,Height,Width,NewBoard,1,Mode).

/* 
    ciclo do jogo em modo Person
*/
game_cycle(Turn,Height,Width,Board,TotalMoves,Mode):-
    (
        (Mode is 1);
        (Mode is 2, Turn is 1);
        (Mode is 3, Turn is 2);
        (Mode is 5, Turn is 1);
        (Mode is 6, Turn is 2)
    ),
    choose_move(Turn,Height,Width,Board,XP,YP,XM,YM,TotalMoves),
    move(Turn,XP,YP,XM,YM,Board,TempBoard),
    UpdatedTotalMoves is TotalMoves + 1,
    append([[XP,YP]],[],VisitedPositions),
    check_continuous_jump_cycle(XP,YP,XM,YM,Turn,Height,Width,UpdatedTotalMoves,TempBoard,NewBoard,VisitedPositions),
    change_player(Turn,NewTurn),
    display_game(NewTurn,Width,NewBoard,UpdatedTotalMoves),
    !,
    game_cycle(NewTurn,Height,Width,NewBoard,UpdatedTotalMoves,Mode).

/*
    ciclo de jogo em modo Easy AI
*/
game_cycle(Turn,Height,Width,Board,TotalMoves,Mode) :-
    (
        (Mode is 2, Turn is 2);
        (Mode is 3, Turn is 1);
        (Mode is 4);
        (Mode is 7, Turn is 1);
        (Mode is 8, Turn is 2)
    ),
    choose_random_move(Turn,Height,Width,Board,XP,YP,XM,YM,[]),
    move(Turn,XP,YP,XM,YM,Board,TempBoard),
    UpdatedTotalMoves is TotalMoves + 1,
    append([[XP,YP]],[],VisitedPositions),
    check_continuous_jump_cycle_random(XP,YP,XM,YM,Turn,Height,Width,UpdatedTotalMoves,TempBoard,NewBoard,VisitedPositions),
    change_player(Turn,NewTurn),
    display_game(NewTurn,Width,NewBoard,UpdatedTotalMoves),
   %sleep(4),
    !,
    game_cycle(NewTurn,Height,Width,NewBoard,UpdatedTotalMoves,Mode).

/*
    ciclo de jogo em modo Difficult AI
*/
game_cycle(Turn,Height,Width,Board,TotalMoves,Mode) :-
    (
        (Mode is 5, Turn is 2);
        (Mode is 6, Turn is 1);
        (Mode is 7, Turn is 2);
        (Mode is 8, Turn is 1);
        (Mode is 9)
    ).
    %select_greddy_move(Turn,Height,Width,Board,X,Y,XP,YP).

/*
    verificar se o jogo acabou, e se sim ver quem ganhou
*/
game_over(Board,Width,Height,Turn,Winner) :-
    change_player(Turn,NewTurn),
    Y is 1,
    check_winner(Board,Width,Height,Y,Turn,FirstWinner),
    FirstWinner is 0,
    !,
    check_winner(Board,Width,Height,Y,NewTurn,SecondWinner),
    SecondWinner is 1,
    Winner is NewTurn.

game_over(_,_,_,Turn,Turn).

congratulate(Winner) :-
    format('Player ~w won!',Winner).
