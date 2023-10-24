:- consult(state).

play :-
    Turn is 1,
    initial_state(Hight,Wide,Board),
    display_game(Turn,Wide,Board),
    game_cycle(Turn,Hight,Wide,Board).