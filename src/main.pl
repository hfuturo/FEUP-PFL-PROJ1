:- consult(state).
:- consult(menu).
:- consult(utils).

play :-
    Turn is 1,
    TotalMoves is 0,
    init_random_state,
    Round is 1,
    menu_game_mode(Mode), nl,
    initial_state(Height,Width,Board),
    display_game_with_round(Turn,Width,Board,TotalMoves,Round),
    game_cycle(Turn,Height,Width,Board,TotalMoves,Mode,Round).