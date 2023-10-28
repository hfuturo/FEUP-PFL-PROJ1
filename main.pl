:- consult(state).

play :-
    Turn is 1,
    TotalMoves is 0,
    initial_state(Height,Width,Board),
    display_game(Turn,Width,Board,TotalMoves),
    
    game_first_play(Turn,Height,Width,Board,NewBoard),

    UpdatedTotalMoves is TotalMoves + 1,
    change_player(Turn,NewTurn),
    UpdatedTotalMoves is TotalMoves + 1,
    display_game(NewTurn,Width,NewBoard,UpdatedTotalMoves),

    game_cycle(NewTurn,Height,Width,NewBoard,UpdatedTotalMoves).
    %game_cycle(Turn,Height,Width,Board,TotalMoves).