:- consult(utils).
:- consult(board).
:- consult(piece).

change_player(1,2).
change_player(2,1).

/*
    create board with specific size
*/
initial_state(Height,Width,Board) :-
    read_size_board(Height,Width),
    make_initial_board(Height,Width,Board),
    write('\n').

/*
    display board
*/
display_game(Turn,Width,Board,TotalMoves) :-
    print_board(Board,Width,Turn,TotalMoves),
    format('It is the turn of the player ~w.\n',Turn),
    !.   % remove output true ? do terminal quando acaba de correr

/*
    cycle of the game
*/
game_cycle(Turn,Height,Width,Board,TotalMoves):-
    write('Write the position of the piece you want to move.\n'),
    choose_move(Turn,Height,Width,Board,XP,YP,XM,YM),
    move(Turn,Height,Width,XP,YP,XM,YM,Board,NewBoard),
    change_player(Turn,NewTurn),
    UpdatedTotalMoves is TotalMoves + 1,
    display_game(NewTurn,Width,NewBoard,UpdatedTotalMoves),
    !,
    game_cycle(NewTurn,Height,Width,NewBoard,UpdatedTotalMoves).


/*
codigo slides stor

game_cycle(Turn,Height,Width,Board):- 
    game_over(Height,Width,Board,Winner), 
    !, 
    congratulate(Winner).
*/