:- use_module(library(system)).

:- consult(utils).
:- consult(board).
:- consult(check_win).
:- consult(piece).
:- consult(move).

change_player(1,2).
change_player(2,1).

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
    player_type(Mode,Turn,Type),
    (Type is 1;Type is 2),

    choose_move(Turn,Height,Width,Board,XP,YP,XM,YM,_,Type),
    move(Turn,XP,YP,XM,YM,Board,NewBoard),
    change_player(Turn,NewTurn),
    display_game(NewTurn,Width,NewBoard,1),
    !,
    game_cycle(NewTurn,Height,Width,NewBoard,1,Mode).


game_cycle(Turn,Height,Width,Board,TotalMoves,Mode):-
    player_type(Mode,Turn,Type),
    (Type is 1;Type is 2),

write('aqui1\n'),


    choose_move(Turn,Height,Width,Board,XP,YP,XM,YM,_,Type),
    move(Turn,XP,YP,XM,YM,Board,TempBoard),
    UpdatedTotalMoves is TotalMoves + 1,
    append([[XP,YP]],[],VisitedPositions),
    check_continuous_jump_cycle(XP,YP,XM,YM,Turn,Height,Width,UpdatedTotalMoves,TempBoard,NewBoard,VisitedPositions,Type),
    change_player(Turn,NewTurn),
    display_game(NewTurn,Width,NewBoard,UpdatedTotalMoves),
    !,
    game_cycle(NewTurn,Height,Width,NewBoard,UpdatedTotalMoves,Mode).

/*
    ciclo de jogo em modo Difficult AI
*/
game_cycle(Turn,Height,Width,Board,TotalMoves,Mode) :-
    player_type(Mode,Turn,Type),
    Type is 3,

    choose_move(Turn, Height, Width, Board, XP, YP, XM, YM,_,Type),
    move(Turn,XP,YP,XM,YM,Board,NewBoard).

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
