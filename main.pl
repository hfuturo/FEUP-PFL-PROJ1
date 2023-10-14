:- consult(state).

play :-
    Turn is 1,
    initial_state(BoardSize,Board),
    display_game(Turn,BoardSize,Board).