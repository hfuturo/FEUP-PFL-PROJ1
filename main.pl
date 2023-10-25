:- consult(state).

play :-
    Turn is 1,
    TotalMoves is 0,
    initial_state(Hight,Wide,Board),
    display_game(Turn,Wide,Board,TotalMoves),
    game_cycle(Turn,Hight,Wide,Board,TotalMoves).