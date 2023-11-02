:- consult(state).
:- consult(menu).
:- consult(utils).

play :-
    init_random_state,
    Round is 1,
    menu_game_mode(Mode), nl,
    initial_state((Height,Width),GameState),
    display_game_with_round(GameState,Round),
    game_cycle((Height,Width),GameState,Mode,Round).
    