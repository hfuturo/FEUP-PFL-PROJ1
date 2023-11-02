:- use_module(library(system)).
:- use_module(library(random)).
:- use_module(library(lists)).
:- use_module(library(between)).

:- consult(state).
:- consult(utils).
:- consult(menu).
:- consult(piece).
:- consult(distance).
:- consult(check_move).
:- consult(check_isolation).
:- consult(check_win).
:- consult(board).
:- consult(move).

play :-
    init_random_state,
    Round is 1,
    menu_game_mode(Mode), nl,
    initial_state((Height,Width),GameState),
    assertz(board_size(Height,Width)),
    display_game_with_round(GameState,Round),
    game_cycle(GameState,Mode,Round),
    retract(board_size(Height,Width)).
    