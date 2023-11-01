:- consult(state).
:- consult(menu).
:- consult(utils).

play :-
    Turn is 1,
    TotalMoves is 0,
    init_random_state,
    menu_game_mode(Mode), nl,
    initial_state(Height,Width,Board),
    display_game(Turn,Width,Board,TotalMoves),
    game_cycle(Turn,Height,Width,Board,TotalMoves,Mode).